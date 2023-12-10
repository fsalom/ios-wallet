//
//  RateDBO.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation
import SwiftData

@Model
final class RateDBO {
    var uid: UUID
    var createdAt: Date
    var identifier: String
    var name: String
    var symbol: String
    var rateUsd: Float

    init(identifier: String, createdAt: Date, name: String, symbol: String, rateUsd: Float) {
        self.uid = UUID()
        self.identifier = identifier
        self.createdAt = createdAt
        self.name = name
        self.symbol = symbol
        self.rateUsd = rateUsd
    }
}
