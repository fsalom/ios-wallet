import Foundation
import SwiftData

@Model
final class CryptoPortfolioDBO {
    @Attribute(.unique) var id: UUID = UUID()
    var quantity: Float
    var priceUsd: Float
    var crypto: CryptoDBO?

    init(quantity: Float, crypto: CryptoDBO, priceUsd: Float) {
        self.quantity = quantity
        self.priceUsd = priceUsd
        self.crypto = crypto
    }
}
