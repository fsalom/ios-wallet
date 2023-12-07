import Foundation
import SwiftData

@Model
final class CryptoDBO {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var symbol: String
    var priceUsd: Float

    init(name: String, symbol: String, priceUsd: Float) {
        self.name = name
        self.symbol = symbol
        self.priceUsd = priceUsd
    }
}
