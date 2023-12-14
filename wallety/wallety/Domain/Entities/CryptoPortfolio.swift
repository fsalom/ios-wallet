//
//  CryptoPortfolio.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation

class CryptoPortfolio: Identifiable {
    var id: UUID
    var crypto: Crypto
    var quantity: Float
    var currency: Rate = Rate.default()
    var valuePerQuantity: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: (crypto.priceUsd/currency.rateUsd) * quantity)
        return "\(currency.currencySymbol)\(formatter.string(from: number) ?? "-")"
    }

    init(id: UUID, crypto: Crypto, quantity: Float) {
        self.id = id
        self.crypto = crypto
        self.quantity = quantity
    }
}
