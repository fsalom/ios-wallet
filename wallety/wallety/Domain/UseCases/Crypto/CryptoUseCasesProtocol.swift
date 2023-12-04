//
//  CryptoUseCaseProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol CryptoUseCasesProtocol {
    func getTopCryptos() async throws -> [Crypto]
}
