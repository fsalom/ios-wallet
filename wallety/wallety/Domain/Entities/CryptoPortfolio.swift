//
//  CryptoPortfolio.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation

class CryptoPortfolio: Identifiable {
    var id: String = UUID().uuidString
    var crypto: Crypto
    var quantity: Float

    init(crypto: Crypto, quantity: Float) {
        self.crypto = crypto
        self.quantity = quantity
    }
}
