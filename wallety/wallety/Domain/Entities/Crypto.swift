//
//  Crypto.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

struct Crypto: Identifiable {
    var id: String = UUID().uuidString
    var reference: String
    var symbol: String
    var name: String
    var priceUsd: Float
    var marketCapUsd: Float
    var imageUrl: URL {
        return URL(string: "https://assets.coincap.io/assets/icons/\(symbol.lowercased())@2x.png")!
    }
    var currency: Rate = Rate.default()
    var changePercent24Hr: Float
    var isFavorite: Bool = false

    var price: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: priceUsd/currency.rateUsd)
        return "\(currency.currencySymbol)\(formatter.string(from: number) ?? "-")"
    }

    var changePercent24HrFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: changePercent24Hr)
        return "\(changePercent24Hr > 0 ? "+" : "")\(formatter.string(from: number) ?? "-")"
    }

    init(symbol: String,
         name: String,
         priceUsd: Float,
         marketCapUsd: Float,
         changePercent24Hr: Float) {
        self.reference = name.lowercased()
        self.symbol = symbol
        self.name = name
        self.changePercent24Hr = changePercent24Hr
        self.priceUsd = priceUsd
        self.marketCapUsd = marketCapUsd
    }
}
