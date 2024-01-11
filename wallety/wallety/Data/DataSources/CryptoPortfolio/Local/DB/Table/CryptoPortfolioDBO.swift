import Foundation
import SwiftData

@Model
final class CryptoPortfolioDBO {
    @Attribute(.unique) var id: String
    var portfolio_id: String = UUID().uuidString
    var quantity: Float
    var priceUsd: Float
    var name: String
    var symbol: String

    init(id: String,
         quantity: Float,
         priceUsd: Float,
         name: String,
         symbol: String) {
        self.id = id
        self.quantity = quantity
        self.priceUsd = priceUsd
        self.name = name
        self.symbol = symbol
    }
}
