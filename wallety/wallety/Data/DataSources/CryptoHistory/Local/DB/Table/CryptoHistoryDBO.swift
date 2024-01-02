//
//  CryptoHistoryDBO.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation
import SwiftData

@Model
final class CryptoHistoryDBO {
    @Attribute(.unique) var id:String
    var quantity: Float
    var priceUsd: Float
    var name: String
    var symbol: String

    init(quantity: Float,
         priceUsd: Float,
         name: String,
         symbol: String) {
        self.id = UUID().uuidString
        self.quantity = quantity
        self.priceUsd = priceUsd
        self.name = name
        self.symbol = symbol
    }
}
