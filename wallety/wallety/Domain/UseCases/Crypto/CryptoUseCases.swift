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
}
