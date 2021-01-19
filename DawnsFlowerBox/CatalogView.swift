//
//  CatalogView.swift
//  DawnsFlowerBox
//
//  Created by Ed Barnes on 29/12/2020.
//

import Foundation
import SwiftUI

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var description: String
    var image: Image {
        Image(name)
    }
    var quantity: Int?
}

struct OverlayView: View {
    var product: Product
    var selected: Bool
    var add: (() -> Void)?
    var body: some View {
        ZStack {
            Color(.white).opacity(selected ? 0.8 : 0.0)
            if selected {
                VStack {
                    HStack {
                        Button("Fave") {
                            print("add to faves")
                        }.buttonStyle(OverlayButton())
                        Button("Add") {
                            self.add!()
                        }.buttonStyle(OverlayButton())
                    }
                }
            }
        }.animation(.easeInOut)
    }
}



struct OverlayButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding()
            .background(Color.fBprimary.cornerRadius(10))
            .shadow(color: Color.black.opacity(0.6), radius: 6, x: 0.0, y: 0.0)
            .overlay(
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white, lineWidth: 0)
                    
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.white.opacity(0.6))
                    }
                }
            )
            .foregroundColor(.white)
    }
}

struct ProductCatalogView: View {
    var product: Product
    @ObservedObject var selected: Selected
    @EnvironmentObject var appCtrl : AppController
    @State var show = false
    var body: some View {
        
        VStack (spacing: 20){
            
            product.image
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    if selected.item != product.id {
                        selected.item = product.id
                    }
                }
                .overlay((selected.item == product.id) ? OverlayView(product: product, selected: true, add: {self.appCtrl.add(product: product)}) : OverlayView(product: product, selected: false))
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                .padding(20)
            
            NavigationLink(
                destination: ProductView(product: product,
                inCart: self.appCtrl.cart.contains(where: {$0.id == product.id}),
                add: {self.appCtrl.add(product: product)},
                close: {self.show.toggle()}), isActive: $show) {
                    HStack {
                        Spacer()
                        VStack {
                            Text(product.name.camelised())
                                .font(.custom("ArchivoNarrow-Regular", size: 20))
                                .padding(.bottom, 4)
                            Text(product.price.monetised())
                                .foregroundColor(.gray)
                        }.padding(.leading, 10)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .padding(.trailing, 10)
                    }.foregroundColor(.black)
                }
            
            Divider().padding(.horizontal, 20)
        }.padding(.bottom, 30)
        
    }
}

struct ProductView: View {
    var product: Product
    var inCart: Bool
    var add: () -> Void
    var close: () -> Void
    @EnvironmentObject var appCtrl : AppController
    @State var added = false
    
    var body: some View {
        ScrollView {
            VStack (spacing: 20){
                HStack {
                    Image(systemName: "arrow.left")
                        .onTapGesture {
                            self.close()
                        }
                }
                
                product.image
                    .resizable()
                    .scaledToFit()
                    
                Text(product.name.camelised())
                Text(product.description)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                
                VStack {
                    if added {
                        HStack {
                            Text("Added")
                            Image(systemName: "checkmark")
                        }
                        .padding(12)
                        .foregroundColor(Color.fBprimary)
                        Text("Add another?")
                            .onTapGesture {
                                self.added.toggle()
                            }
                    } else {
                        if inCart {
                            Button(action: {self.add(); self.added.toggle()}) {
                                HStack {
                                    Text("Add again")
                                    Image(systemName: "plus")
                                }
                            }
                                .padding(12)
                                .background(Color.fBprimary)
                                .cornerRadius(3.0)
                                .foregroundColor(.white)
                                
                        } else {
                            Button(action: {self.add(); self.added.toggle()}) {
                                HStack {
                                    Text("Add to Cart")
                                    Image(systemName: "plus")
                                }
                            }
                            .padding(12)
                            .background(Color.fBprimary)
                            .cornerRadius(3.0)
                            .foregroundColor(.white)
                        }
                    }
                }.font(.custom("RobotoCondensed-Bold", size: 14))
                
            }.padding(10)
            .onAppear{
                print("before changing: \(self.appCtrl.browseScrollID)")
                self.appCtrl.browseScrollID = product.id.uuidString
                print("after: \(product.id.hashValue)")
            }
        }
    }
}



class Selected: ObservableObject {
    @Published var item = UUID()
}

struct CatalogView: View {
    @ObservedObject var selected = Selected()
    @EnvironmentObject var appCtrl : AppController
    @State private var searchValue = ""
    var body: some View {
        let search = Binding (
            get: {self.searchValue},
            set: {self.searchValue = $0} )

        return NavigationView {
            
            VStack{
                ScrollView{
                    ScrollViewReader {scroll in
                        HStack{
                            //Text("Options")
                            Text("Sort")
                                .contextMenu(ContextMenu(menuItems: {
                                    
                                    Button(action: {print("option 1")}) {
                                        HStack {
                                            Text("A Z")
                                            Image(systemName: "arrow.down")
                                            Spacer()
                                        }
                                    }
                                    
                                    Button(action: {print("option 1")}) {
                                        HStack {
                                            Text("A Z")
                                            Image(systemName: "arrow.up")
                                            Spacer()
                                        }
                                    }
                                }))
                             
                            TextField("Search", text: search)
                                .padding(10)
                                .foregroundColor(.black)
                                .background(Color.white)
                                .cornerRadius(3.0)
                                .padding(.leading, 20)
                            Spacer()
                        }
                        .onAppear {
                            //print("appeared")
                            //print("sscrolling to: \(self.appCtrl.browseScrollID)")
                            scroll.scrollTo(self.appCtrl.browseScrollID, anchor: .center)
                        }
                        .font(.custom("RobotoCondensed-Bold", size: 20))
                        .id("start")
                        .padding(30)
                        .onAppear{scroll.scrollTo(2)}
                        .background(Color.fBprimary)
                        .foregroundColor(.white)
                        
                        ForEach(example_products, id: \.id) { item in
                            ProductCatalogView(product: item, selected: selected)
                                .id(item.id.uuidString)
                        }.environmentObject(selected)
                        
                        .id("sort")
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView().environmentObject(AppController())
    }
}
