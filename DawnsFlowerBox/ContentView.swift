//
//  ContentView.swift
//  DawnsFlowerBox
//
//  Created by Ed Barnes on 29/12/2020.
//

import SwiftUI

enum Page {
    case browse
    case cart
    case checkout
}

class AppController: ObservableObject {
    @Published var page: Page = .browse
    @Published var basketCount = 0
    @Published var cartSum: Double = 0
    @Published var cart = [Product]() {
        didSet {
            if oldValue.count < cart.count {
                showAdded = true
            }
        }
    }
    @Published var test_crt = test_cart
    @Published var browseScrollID = "start"
    @Published var showAdded = false {
        didSet {
            if showAdded == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.showAdded = false
                }
            }
        }
    }
    
    @Published var removalWarn = false
    @Published var removalIndex = 0
    
    func count() {
        var total = 0
        var moneySum: Double = 0
        print("counting")
        for i in self.cart {
            print(i)
            if i.quantity != nil {
                print("exists")
                total += i.quantity!
                moneySum += Double(i.quantity!) * i.price
                print("added \(i.quantity!) to total")
                
            } else {
                print("adding 1 to count")
                total += 1
                moneySum += i.price
            }
            
            print(total)
        }
        self.cartSum = moneySum
        self.basketCount = total
    }
    
    func add(product: Product) {
        if let i = self.cart.firstIndex(where: {$0.id == product.id}) {
            if let val = self.cart[i].quantity {
                print("Adding 1 to quantity")
                self.cart[i].quantity! += 1
                print("new quantity is \(val)")
            } else {
                self.cart[i].quantity = 2
                print("created quantity")
            }
        } else {
            let prodToAdd = Product(id: product.id, name: product.name, price: product.price, description: product.description, quantity: 1)
            self.cart.append(prodToAdd)
        }
        if page == .browse {
            self.showAdded = true
        }
        
        count()
    }
    
    func decrease(product: Product) {
        if let i = self.cart.firstIndex(where: {$0.id == product.id}) {
            if self.cart[i].quantity == 1 {
                print("warn")
                removalIndex = i
                removalWarn.toggle()
            } else {
                self.cart[i].quantity! -= 1
                self.cartSum -= self.cart[i].price
            }
        }
    }
    
    func remove() {
        self.cartSum -= self.cart[removalIndex].price
        self.cart.remove(at: removalIndex)
        
    }
}

struct ContentView: View {
    @EnvironmentObject var appCtrl : AppController
    
    var body: some View {
        ZStack {
            Color.fBprimary
            .ignoresSafeArea()
            VStack (spacing: 0){
                VStack {
                    Spacer()
                    HStack (spacing: 20){
                        Image("dfb_flower_logo")
                            .resizable()
                            .scaledToFit()
                            .padding(.leading, 20)
                            .onTapGesture {
                                self.appCtrl.page = .browse
                            }
                        Spacer()
                        Text("Browse")
                            .onTapGesture {
                                self.appCtrl.page = .browse
                            }
                        Divider().background(Color.white)
                        ZStack {
                            Text("Cart")
                                .onTapGesture {
                                    self.appCtrl.page = .cart
                                }
                            if !self.appCtrl.cart.isEmpty {
                                Text(String(self.appCtrl.basketCount))
                                    //.padding(3)
                                    .foregroundColor(.fBprimary)
                                    .font(.caption)
                                    .background(
                                        Circle()
                                            
                                            .fill(Color.white)
                                            .frame(width: 17, height: 17, alignment: .center)
                                    )
                                    .offset(x: 22.0, y: -14.0)
                            }
                        }.padding(.trailing, 20)
                        
                    }.frame(height: 40, alignment: .center)
                    .foregroundColor(.white)
                    .font(.custom("RobotoCondensed-Bold", size: 18))
                    //.padding(.bottom, 20)
                    //Spacer()
                }
                //.clipped()
                .frame(height: 50)
                
                Divider()
                    .blur(radius: 3.0)
                    .frame(height: 6)
                
                switch appCtrl.page {
                case .browse:
                    CatalogView().environmentObject(appCtrl)
                case .cart:
                    CartView().environmentObject(appCtrl)
                case .checkout:
                    CheckoutView().environmentObject(appCtrl)
                }
            }
            .blur(radius: self.appCtrl.removalWarn ? 3.0 : 0.0)
            .disabled(self.appCtrl.removalWarn ? true : false)
            
            if self.appCtrl.showAdded {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundColor(Color.fBprimary)
                        .font(.custom("RobotoCondensed-Bold", size: 100))
                        .padding(40)
                        .background(Color.white.opacity(0.6))
                }
            }
            if self.appCtrl.removalWarn {
                RemovalWarnView(keep: {self.appCtrl.removalWarn.toggle()}, remove: {self.appCtrl.remove(); self.appCtrl.removalWarn.toggle()})
            }
        }
    }
}

struct RemovalWarnView: View {
    var keep: () -> Void
    var remove: () -> Void
    var body: some View {
        VStack {
            Text("Are you sure you want to remove this item from your cart?")
                .multilineTextAlignment(.center)
            HStack (spacing: 10) {
                Text("Keep")
                    .padding(20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .onTapGesture {
                        keep()
                    }
                Text("Remove")
                    .padding(20)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .onTapGesture {
                        remove()
                    }
            }.padding(20)
        }.frame(width: 280, height: 220, alignment: .center)
        .padding(40)
        .background(Color.white)
        .cornerRadius(10)
        .clipped()
        .shadow(color: Color.black, radius: 6)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppController())
    }
}
