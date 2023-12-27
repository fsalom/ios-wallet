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

    func getCrypto(with symbol: String) async throws -> Crypto? {
        try await repository.getCrypto(with: symbol)
    }

    func getCryptos() async throws -> [Crypto] {
        try await repository.getCryptos()
    }

    func update(these cryptos: [Crypto], with currency: Rate) -> [Crypto] {
        var updatedCryptos: [Crypto] = []
        cryptos.forEach { crypto in
            crypto.currency = currency
            updatedCryptos.append(crypto)
        }
        return updatedCryptos
    }

    func filter(these cryptos: [Crypto], with text: String) -> [Crypto] {
        return cryptos.filter({$0.name.lowercased().contains(text.lowercased())})
    }

    func favOrUnfav(this symbol: String) async throws {
        try await repository.favOrUnfav(this: symbol)
    }
}
