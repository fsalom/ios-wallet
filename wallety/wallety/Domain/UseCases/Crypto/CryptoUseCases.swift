//
//  CryptoUseCase.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoUseCases: CryptoUseCasesProtocol {
    let repository: CryptoRepositoryProtocol

    init(repository: CryptoRepositoryProtocol) {
        self.repository = repository
    }

    func getIsUpdatedAndCryptos() async throws -> (Bool, [Crypto]) {
        try await repository.getIsUpdatedAndCryptos()
    }

    func getIsUpdatedAndCryptosPortfolio() async throws -> (Bool, [CryptoPortfolio]) {
        let (isUpdated, cryptosPortfolio) = try await repository.getIsUpdatedAndCryptosPortfolio()
        var myCryptosPortolio: [CryptoPortfolio] = []
        for portfolio in cryptosPortfolio {
            guard let index = myCryptosPortolio.firstIndex(
                where: {$0.crypto.symbol == portfolio.crypto.symbol}
            ) else {
                myCryptosPortolio.append(portfolio)
                continue
            }
            myCryptosPortolio[index].quantity += portfolio.quantity
        }
        return (isUpdated, myCryptosPortolio)
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float) async throws {
        try await repository.addToMyPorfolio(this: crypto, with: quantity)
    }
}
