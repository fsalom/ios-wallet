import Foundation
import SwiftData

@Model
final class FavoriteCryptoDBO {
    @Attribute(.unique) var symbol: String

    init(symbol: String) {
        self.symbol = symbol
    }
}
