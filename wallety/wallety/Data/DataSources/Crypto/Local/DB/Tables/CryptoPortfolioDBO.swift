import Foundation
import SwiftData

@Model
final class CryptoPortfolioDBO {
    var quantity: String
    var crypto: CryptoDBO
    var priceUsd: Float

    init(quantity: String, crypto: CryptoDBO, priceUsd: Float) {
        self.quantity = quantity
        self.crypto = crypto
        self.priceUsd = priceUsd
    }
}
