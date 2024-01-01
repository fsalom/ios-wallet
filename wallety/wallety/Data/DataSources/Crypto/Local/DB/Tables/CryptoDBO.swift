import Foundation
import SwiftData

@Model
final class CryptoDBO {
    var name: String
    var symbol: String
    var priceUsd: Float
    var marketCapUsd: Float? = 0.0
    var changePercent24Hr: Float? = 0.0

    init(name: String,
         symbol: String,
         priceUsd: Float,
         marketCapUsd: Float = 0.0,
         changePercent24Hr: Float = 0.0) {
        self.name = name
        self.symbol = symbol
        self.priceUsd = priceUsd
        self.marketCapUsd = marketCapUsd
        self.changePercent24Hr = changePercent24Hr
    }
}
