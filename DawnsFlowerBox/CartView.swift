//
//  CartView.swift
//  DawnsFlowerBox
//
//  Created by Ed Barnes on 29/12/2020.
//

import SwiftUI

struct CartItem: View {
    var product: Product
    var add: () -> Void
    var decrease: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                product.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack {
                    Text(product.name.camelised())
                        .font(.custom("RobotoCondensed-Regular", size: 18))
                }
                Spacer()
            }.padding(.leading, 20)
            HStack {
                Text((product.price * Double(product.quantity!)).monetised())
                    .padding(20)
                Spacer()
                Text("Qty")
                    .font(.caption)
                Text(product.quantity != nil ? String(product.quantity!) : "1" )
                    .font(.custom("RobotoCondensed-Regular", size: 22))
                    .padding(20)
                    
                VStack{
                    Button(action: add) {
                        Image(systemName: "plus")
                    }.buttonStyle(PlusMinus())
                    .padding(.bottom, 1)
                    Button(action: decrease) {
                        Image(systemName: "minus")
                    }.buttonStyle(PlusMinus())
                }
            }.padding(.trailing, 14)
        }
    }
}

struct PlusMinus: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .frame(width: 30, height: 30, alignment: .center)
            .overlay(
                ZStack {
                    if configuration.isPressed {
                    RoundedRectangle(cornerRadius: 3.0)
                        .stroke(Color.gray, lineWidth: 1)
                        .shadow(color: Color.black, radius: 2 )
                        .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 3.0)
                            .stroke(Color.gray, lineWidth: 1)
                            .clipped()
                    }
                }
                
            )
            .cornerRadius(3.0)
    }
}

struct CartView: View {
    @EnvironmentObject var appCtrl : AppController
    
    var body: some View {
        ScrollView {
            VStack {
                if !self.appCtrl.cart.isEmpty {
                    ForEach(self.appCtrl.cart, id: \.id) { item in
                        CartItem(product: item,
                                 add: {self.appCtrl.add(product: item)},
                                 decrease: {self.appCtrl.decrease(product: item)}
                        
                        ).padding(.vertical, 20)
                    }
                    Divider()
                        .padding(10)
                    HStack {
                        Text("Total:")
                        Spacer()
                        Text(self.appCtrl.cartSum.monetised())
                        Spacer()
                    }
                    .padding(20)
                    .font(.custom("RobotoCondensed-Regular", size: 22))
                    
                    Spacer()
                    
                    Button(action: {self.appCtrl.page = .checkout}) {
                        
                        HStack {
                            Text("Checkout")
                            Image(systemName: "lock.fill")
                        }
                        .frame(width: 126, height: 56)
                        .background(Color.niceYellow)
                        .font(.custom("RobotoCondensed-Bold", size: 20))
                        .cornerRadius(6.0)
                        .foregroundColor(.black)
                        .padding(3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black, lineWidth: 2)
                                .frame(width: 118, height: 48)
                        )
                        .clipped()
                        .shadow(color: Color.black, radius: 2)
                        
                    }.padding(30)
                } else {
                    Text("Your cart is empty.")
                        .font(.title)
                        .foregroundColor(Color.fBprimary)
                        .padding(30)
                    HStack {
                        Text("Take me to the flowers")
                            .foregroundColor(Color.fBprimary)
                        Image(systemName: "cart.circle")
                            .foregroundColor(Color.fBprimary)
                            .font(.title)
                    }.onTapGesture {
                        self.appCtrl.page = .browse
                    }
                }
            }
        }.background(Color.white)
    }
}



struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView().environmentObject(AppController())
    }
}
