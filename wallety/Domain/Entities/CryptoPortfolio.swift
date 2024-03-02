//
//  CryptoPortfolio.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation

class CryptoPortfolio: Identifiable {
    var id: String
    var crypto: Crypto
    var quantity: Float
    var purchasePrice: Float
    var purchaseCurrency: String
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
    var quantityFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: quantity)
        return "\(formatter.string(from: number) ?? "-")"
    }

    var purchasePriceFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: purchasePrice == 0.0 ? crypto.priceForCurrency : purchasePrice)
        return "\(formatter.string(from: number) ?? "-")"
    }

    init(id: String,
         crypto: Crypto,
         quantity: Float,
         purchasePrice: Float,
         purchaseCurrency: String) {
        self.id = id
        self.crypto = crypto
        self.quantity = quantity
        self.purchasePrice = purchasePrice
        self.purchaseCurrency = purchaseCurrency
    }
}
