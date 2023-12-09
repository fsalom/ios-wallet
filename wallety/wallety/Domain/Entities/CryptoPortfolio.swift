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

    init(id: UUID, crypto: Crypto, quantity: Float) {
        self.id = id
        self.crypto = crypto
        self.quantity = quantity
    }
}
