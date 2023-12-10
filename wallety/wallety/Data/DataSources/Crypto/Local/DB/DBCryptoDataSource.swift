//
//  CoinDBDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftData

class DBCryptoDataSource: LocalCryptoDataSourceProtocol {
    
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

    func getCryptos() async throws -> [CryptoDBO] {
        try context.fetch(FetchDescriptor<CryptoDBO>())
    }

    func getCrypto(with symbol: String) async throws -> CryptoDBO? {
        try context.fetch(FetchDescriptor<CryptoDBO>(
            predicate: #Predicate {
                $0.symbol == symbol
            })
        ).first
    }

    func getCryptoPortfolio() async throws -> [CryptoPortfolioDBO] {
        try context.fetch(FetchDescriptor<CryptoPortfolioDBO>())
    }

    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolioDBO] {
        try context.fetch(FetchDescriptor<CryptoPortfolioDBO>(
            predicate: #Predicate {
                $0.symbol == symbol
            })
        )
    }

    func addToMyPortfolio(this crypto: CryptoDBO, with quantity: Float, and price: Float) async throws {
        let cryptoPorfolioDBO = CryptoPortfolioDBO(quantity: quantity, priceUsd: price, name: crypto.name, symbol: crypto.symbol)
        context.insert(cryptoPorfolioDBO)
        try context.save()        
    }

    func delete(this id: UUID) async throws {
        try context.delete(model: CryptoPortfolioDBO.self, where: #Predicate { portfolio in
            portfolio.id == id
        })
    }
}