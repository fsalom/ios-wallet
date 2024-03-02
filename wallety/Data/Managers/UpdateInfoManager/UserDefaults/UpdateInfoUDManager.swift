//
//  UpdateInfoManager.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/1/24.
//

import Foundation

class UpdateInfoUDManager: UpdateInfoManagerProtocol {
    var storage: CacheManagerProtocol

    let dateFormat: String = "yyyyMMddHHmm"

    init(storage: CacheManagerProtocol) {
        self.storage = storage
    }

    func shouldUpdate(this option: String, after seconds: Int) -> Bool {
        guard let lastUpdated = getDate(for: option) else {
            return true
        }
        let elapsed = Date.now.timeIntervalSince(lastUpdated)
        return Int(elapsed) > seconds ? true : false
    }

    func setDate(for option: String, isResetNeeded: Bool = false) {
        let lastUpdated: Date = isResetNeeded ? .distantPast : .now
        storage.set(option, lastUpdated)
    }

    private func getDate(for option: String) -> Date? {
        guard let lastUpdatedInfo = storage.get(anyFor: option) else {
            return nil
        }
        return lastUpdatedInfo as? Date
    }

    private func getString(of date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    private func getDate(of string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: string)
    }
}
