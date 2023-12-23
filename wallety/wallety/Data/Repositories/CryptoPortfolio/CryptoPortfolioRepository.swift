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

    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio] {
        let cryptosPortfolio = try await localDataSource.getPortfolio(with: symbol)
        return cryptosPortfolio.map { $0.toDomain() }
    }

    func delete(this portfolio: CryptoPortfolio) async throws {
        try await localDataSource.delete(this: portfolio.toDBO())
    }
}

fileprivate extension CryptoPortfolioDBO {
    func toDomain() -> CryptoPortfolio {
        return CryptoPortfolio(crypto: Crypto(
            symbol: symbol,
            name: name,
            priceUsd: priceUsd),
            quantity: quantity)
    }
}

fileprivate extension CryptoPortfolio {
    func toDBO() -> CryptoPortfolioDBO {
        return CryptoPortfolioDBO(quantity: quantity,
                                  priceUsd: crypto.priceUsd,
                                  name: crypto.name,
                                  symbol: crypto.symbol)
    }
}
