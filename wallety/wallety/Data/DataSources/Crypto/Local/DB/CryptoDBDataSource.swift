//
//  CoinDBDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftData

class CryptoDBDataSource: LocalCryptoDataSourceProtocol {
    var swiftDataManager: SwiftDataManager

    init(swiftDataManager: SwiftDataManager) {
        self.swiftDataManager = swiftDataManager
    }

    func save(these cryptos: [CryptoDBO]) async throws {
        for crypto in cryptos {
            await swiftDataManager.insert(item: crypto)
        }
        try await swiftDataManager.save()
    }
    
    func getCryptos() async throws -> [CryptoDBO] {
        try await swiftDataManager.fetchAll(CryptoDBO.self)
    }
}
