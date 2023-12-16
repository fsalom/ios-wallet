//
//  Crypto.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class Crypto: Identifiable {
    var id: String = UUID().uuidString
    var reference: String
    var symbol: String
    var name: String
    var priceUsd: Float
    var imageUrl: URL {
        return URL(string: "https://assets.coincap.io/assets/icons/\(symbol.lowercased())@2x.png")!
    }
    var currency: Rate = Rate.default()

    var price: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: priceUsd/currency.rateUsd)
        return "\(currency.currencySymbol)\(formatter.string(from: number) ?? "-")"
    }

    init(symbol: String, name: String, priceUsd: Float) {
        self.reference = name.lowercased()
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
    }
}
