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
                         symbol: String ,
                         with quantity: Float,
                         and price: Float) async throws {
        try await localDataSource.addToMyPortfolio(this: crypto,
                                                   symbol: symbol,
                                                   with: quantity,
                                                   and: price)
    }

    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolio] {
        try await localDataSource.getPortfolios(with: symbol).map({$0.toDomain()})
    }

    func delete(this portfolio: CryptoPortfolio) async throws {
        try await localDataSource.delete(this: portfolio.id)
    }
}

fileprivate extension CryptoPortfolioDBO {
    func toDomain() -> CryptoPortfolio {
        return CryptoPortfolio(id: portfolio_id,
            crypto: Crypto(
            symbol: symbol,
            name: name,
            priceUsd: priceUsd, 
            marketCapUsd: 0.0,
            changePercent24Hr: 0.0),
            quantity: quantity)
    }
}

fileprivate extension CryptoPortfolio {
    func toDBO() -> CryptoPortfolioDBO {
        return CryptoPortfolioDBO(id: id,
                                  quantity: quantity,
                                  priceUsd: crypto.priceUsd,
                                  name: crypto.name,
                                  symbol: crypto.symbol)
    }
}
