//
//  CryptoPortfolioRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation

class CryptoPortfolioRepository: CryptoPortfolioRepositoryProtocol {
    var localDataSource: LocalCryptoPortfolioDataSourceProtocol

    init(localDataSource: LocalCryptoPortfolioDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        return try await localDataSource.getCryptoPortfolio().map({$0.toDomain()})
    }

    func addToMyPorfolio(this crypto: String,
                         symbol: String,
                         rateId: String,
                         rateUsd: Float,
                         with quantity: Float,
                         and price: Float) async throws {
        try await localDataSource.addToMyPortfolio(this: crypto,
                                                   symbol: symbol,
                                                   rateId: rateId,
                                                   rateUsd: rateUsd,
                                                   with: quantity,
                                                   and: price)
    }

    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolio] {
        try await localDataSource.getPortfolios(with: symbol).map(
            {
                $0.toDomain()
            }
        )
    }

    func delete(this portfolio: CryptoPortfolio) async throws {
        try await localDataSource.delete(this: portfolio.id)
    }
}

fileprivate extension CryptoPortfolioDBO {
    func toDomain() -> CryptoPortfolio {
        var crypto = Crypto(
            symbol: symbol,
            name: name,
            priceUsd: 0.0,
            marketCapUsd: 0.0,
            changePercent24Hr: 0.0)
        return CryptoPortfolio(
            id: portfolio_id,
            crypto: crypto,
            quantity: quantity,
            purchasePrice: priceUsd,
            purchaseCurrency: rateId)
    }
}

fileprivate extension CryptoPortfolio {
    func toDBO() -> CryptoPortfolioDBO {
        return CryptoPortfolioDBO(
            id: id,
            quantity: quantity,
            rateId: currency.identifier,
            rateUsd: currency.rateUsd,
            priceUsd: crypto.priceUsd,
            name: crypto.name,
            symbol: crypto.symbol)
    }
}
