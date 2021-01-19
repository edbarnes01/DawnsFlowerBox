//
//  Utils.swift
//  DawnsFlowerBox
//
//  Created by Ed Barnes on 19/01/2021.
//

import SwiftUI

extension String {
    func camelised() -> String {
        return self.replacingOccurrences(of: "_", with: " ").capitalized
    }
}

extension Double {
    func monetised() -> String {
        return ("£\(String(self))")
    }
}

let example_products = [
    Product(name: "a_beautiful_snowflake", price: 30.00, description: "Snowy white beautiful flowers in this lovely bouquet  a mixture of lilies, blooms, carnations, white stallion and snowy cones. Flowers may vary."),
    Product(name: "a_deep_love", price: 60.00, description: "The passionate colours of red and purple together look stunning. This hand tied gift includes 12 red roses, purple lizzianthus and delicate foilages. Depending on stock levels, may not be available for same day delivery. The image shown is for illustration purposes only and may vary. See T&Cs"),
    Product(name: "a_dozen_red_roses_gift_bag", price: 55.00, description: "A gorgeous aqua packed bouquet of 12 red roses and foilage or you can choose the flat packed bouquet style if you prefer. A very romantic gift for a special person in your life. Depending on stock levels not always available for same day delivery.")]

let test_cart = [
    Product(name: "a_beautiful_snowflake", price: 30.00, description: "Snowy white beautiful flowers in this lovely bouquet  a mixture of lilies, blooms, carnations, white stallion and snowy cones. Flowers may vary."),
    Product(name: "a_deep_love", price: 60.00, description: "The passionate colours of red and purple together look stunning. This hand tied gift includes 12 red roses, purple lizzianthus and delicate foilages. Depending on stock levels, may not be available for same day delivery. The image shown is for illustration purposes only and may vary. See T&Cs", quantity: 3)]

extension Color {
    public static let fBprimary = Color(red: 178.0 / 255.0, green: 42.0 / 255.0, blue: 92.0 / 255.0)
    public static let niceYellow = Color(red: 250 / 255, green: 227 / 255, blue: 119 / 255)
}
