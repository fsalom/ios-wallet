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

    init(id: String, symbol: String, name: String, priceUsd: Float) {
        self.reference = id
        self.symbol = symbol
        self.name = name
        self.priceUsd = priceUsd
    }
}
