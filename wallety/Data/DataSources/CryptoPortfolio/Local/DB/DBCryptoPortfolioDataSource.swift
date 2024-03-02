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

    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolioDBO] {
        try context.fetch(FetchDescriptor<CryptoPortfolioDBO>(
            predicate: #Predicate {
                $0.symbol == symbol
            })
        )
    }

    func addToMyPortfolio(this crypto: String,
                          symbol: String,
                          rateId: String,
                          rateUsd: Float,
                          with quantity: Float,
                          and price: Float) async throws {
        let cryptoPorfolioDBO = CryptoPortfolioDBO(id: UUID().uuidString,
                                                   quantity: quantity,
                                                   rateId: rateId,
                                                   rateUsd: rateUsd,
                                                   priceUsd: price,
                                                   name: crypto,
                                                   symbol: symbol)
        context.insert(cryptoPorfolioDBO)
        try context.save()
    }

    func delete(this id: String) async throws {
        if let portfolio = try context.fetch(FetchDescriptor<CryptoPortfolioDBO>(
            predicate: #Predicate {
                $0.portfolio_id == id
            })
        ).first {
            context.delete(portfolio)
            try context.save()
        }
    }
}
