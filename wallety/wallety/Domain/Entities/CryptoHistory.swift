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
    var day: String {
        time.toString(with: "YYYY-MM-dd")
    }

    var dayAndHour: String {
        time.toString(with:  "YYYY-MM-dd HH:mm")
    }

    init(time: Int, priceUsd: Float) {
        self.time = time
        self.priceUsd = priceUsd
    }
}

fileprivate extension Int {
    func toString(with format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
