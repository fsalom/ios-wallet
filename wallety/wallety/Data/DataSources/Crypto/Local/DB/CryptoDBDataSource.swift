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
            swiftDataManager.context?.insert(crypto)
            try swiftDataManager.context?.save()
        }
    }

    func save(this crypto: CryptoDBO)  async throws {
        swiftDataManager.context?.insert(crypto)
        try swiftDataManager.context?.save()
    }

    func getCryptos() async throws -> [CryptoDBO] {
        try swiftDataManager.context?.fetch(FetchDescriptor<CryptoDBO>()) ?? []
    }

    func getCrypto(with symbol: String) async throws -> CryptoDBO? {
        try swiftDataManager.context?.fetch(FetchDescriptor<CryptoDBO>(
            predicate: #Predicate {
                $0.symbol == symbol
            })
        ).first
    }

    func getMyCryptoPortfolio() async throws -> [CryptoPortfolioDBO] {
        try swiftDataManager.context?.fetch(FetchDescriptor<CryptoPortfolioDBO>()) ?? []
    }

    func addToMyPortfolio(this crypto: CryptoDBO, with quantity: Float) async throws {
        let cryptoPorfolioDBO = CryptoPortfolioDBO(quantity: quantity, crypto: crypto, priceUsd: 0)
        swiftDataManager.context?.insert(cryptoPorfolioDBO)
        try swiftDataManager.context?.save()
    }
}
