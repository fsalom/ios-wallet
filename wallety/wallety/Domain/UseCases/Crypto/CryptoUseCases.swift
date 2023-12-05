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

    func getTopCryptos() async throws -> [Crypto] {
        try await repository.getTopCrypto()
    }

    func getMyCryptos() async throws -> [Crypto] {
        try await repository.getTopCrypto()
    }
}
