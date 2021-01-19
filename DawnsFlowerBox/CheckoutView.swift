//
//  CheckoutView.swift
//  DawnsFlowerBox
//
//  Created by Ed Barnes on 30/12/2020.
//

import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var appCtrl : AppController
    
    var body: some View {
        VStack {
            Spacer()
            Text("Nothing here yet!")
                .font(.custom("RobotoCondensed-Bold", size: 36))
            Spacer()
            HStack {
                Image(systemName: "arrow.backward.circle")
                Text("Back")
            }
            .font(.custom("RobotoCondensed-Bold", size: 26))
            .onTapGesture {
                self.appCtrl.page = .cart
            }
            Spacer()
        }.foregroundColor(.white)
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
