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
    var currencySymbol: String
    var symbol: String
    var rateUsd: Float
    var isSelected: Bool

    init(identifier: String,
         createdAt: Date,
         currencySymbol: String,
         symbol: String,
         rateUsd: Float,
         isSelected: Bool = false) {
        self.uid = UUID()
        self.identifier = identifier
        self.createdAt = createdAt
        self.currencySymbol = currencySymbol
        self.symbol = symbol
        self.rateUsd = rateUsd
        self.isSelected = isSelected
    }
}
