//
//  Rate.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

class Rate: Identifiable {
    var uid: String = UUID().uuidString
    var identifier: String
    var currencySymbol: String
    var symbol: String
    var rateUsd: Float
    var rateUsdFormatted: String {
        getFormat(for: rateUsd)
    }

    init(uid: String, identifier: String, currencySymbol: String, symbol: String, rateUsd: Float) {
        self.uid = uid
        self.identifier = identifier
        self.currencySymbol = currencySymbol
        self.symbol = symbol
        self.rateUsd = rateUsd
    }

    static func `default`() -> Rate {
        Rate(uid: UUID().uuidString,
             identifier: "",
             currencySymbol: "$",
             symbol: "USD",
             rateUsd: 1)
    }

    func getFormat(for quantity: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 3
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: quantity)
        return formatter.string(from: number) ?? "-"
    }
}
