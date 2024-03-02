import Foundation
import SwiftData

@Model
final class CryptoPortfolioDBO {
    @Attribute(.unique) var id: String
    var portfolio_id: String = UUID().uuidString
    var quantity: Float
    var rateId: String = "USD"
    var rateUsd: Float = 1.0
    var priceUsd: Float
    var name: String
    var symbol: String

    init(id: String,
         quantity: Float,
         rateId: String,
         rateUsd: Float,
         priceUsd: Float,
         name: String,
         symbol: String) {
        self.id = id
        self.quantity = quantity
        self.rateId = rateId
        self.rateUsd = rateUsd
        self.priceUsd = priceUsd
        self.name = name
        self.symbol = symbol
    }
}
