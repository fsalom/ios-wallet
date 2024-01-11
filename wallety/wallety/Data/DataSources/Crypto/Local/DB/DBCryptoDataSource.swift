//
//  CoinDBDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftData

actor DBCryptoDataSource: LocalCryptoDataSourceProtocol {
    
    private var context: ModelContext

    init(with container: ModelContainer) {
        context = ModelContext(container)
    }

    func save(these cryptos: [CryptoDBO]) async throws {
        for crypto in cryptos {
            context.insert(crypto)
        }
        try context.save()
    }

    func save(this crypto: CryptoDBO)  async throws {
        context.insert(crypto)
        try context.save()
    }

    func deleteAll() async throws {
        try context.delete(model: CryptoDBO.self)
    }

    func getCryptos() async throws -> [CryptoDBO] {
        try context.fetch(FetchDescriptor<CryptoDBO>(sortBy: [SortDescriptor(\.marketCapUsd)]))
    }

    func getCrypto(with symbol: String) async throws -> CryptoDBO? {
        try context.fetch(FetchDescriptor<CryptoDBO>(
            predicate: #Predicate {
                $0.symbol == symbol
            })
        ).first
    }

    func favOrUnfav(this symbol: String) async throws {
        if let fav = try context.fetch(FetchDescriptor<FavoriteCryptoDBO>(
            predicate: #Predicate {
                $0.symbol == symbol
            })
        ).first {
            context.delete(fav)
            try context.save()
        } else {
            context.insert(FavoriteCryptoDBO(symbol: symbol))
            try context.save()
        }
    }

    func getFavorites() async throws -> [FavoriteCryptoDBO] {
        try context.fetch(FetchDescriptor<FavoriteCryptoDBO>())
    }
}
