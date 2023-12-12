//
//  CryptoPortfolioUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/12/23.
//

import Foundation

class CryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol {
    let repository: CryptoRepositoryProtocol

    init(repository: CryptoRepositoryProtocol) {
        self.repository = repository
    }

    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        []
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) async throws {
        try await repository.addToMyPorfolio(this: crypto, with: quantity, and: price)
    }

    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio] {
        try await repository.getPortfolio(with: symbol)
    }

    func delete(this portfolio: CryptoPortfolio) async throws {
        try await repository.delete(this: portfolio)
    }
}
