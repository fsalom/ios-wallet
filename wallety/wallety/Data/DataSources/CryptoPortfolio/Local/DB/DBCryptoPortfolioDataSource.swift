//
//  DBCryptoPortfolioDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation
import SwiftData

actor DBCryptoPortfolioDataSource: LocalCryptoPortfolioDataSourceProtocol {
    private var context: ModelContext

    init(with container: ModelContainer) {
        context = ModelContext(container)
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

    func addToMyPortfolio(this crypto: String,
                          symbol: String,
                          with quantity: Float,
                          and price: Float) async throws {
        let cryptoPorfolioDBO = CryptoPortfolioDBO(quantity: quantity,
                                                   priceUsd: price,
                                                   name: crypto,
                                                   symbol: symbol)
        context.insert(cryptoPorfolioDBO)
        try context.save()
    }

    func delete(this portfolio: CryptoPortfolioDBO) async throws {
        context.delete(portfolio)
    }
}
