//
//  CryptoHistory.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

class CryptoHistory {
    var time: Int
    var priceUsd: Float
    var crypto: String = ""
    var dateString: String {
        let date = Date(timeIntervalSince1970: TimeInterval(time/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }

    init(time: Int, priceUsd: Float) {
        self.time = time
        self.priceUsd = priceUsd
    }
}
