import Foundation
import SwiftData

@Model
final class CryptoPortfolioDBO {
    var quantity: Float
    var priceUsd: Float
    var name: String
    var symbol: String

    init(quantity: Float,
         priceUsd: Float,
         name: String,
         symbol: String) {
        self.quantity = quantity
        self.priceUsd = priceUsd
        self.name = name
        self.symbol = symbol
    }
}
