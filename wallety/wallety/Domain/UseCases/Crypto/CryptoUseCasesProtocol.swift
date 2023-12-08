//
//  CryptoUseCaseProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol CryptoUseCasesProtocol {
    func getIsUpdatedAndCryptos() async throws -> (Bool, [Crypto])
    func getIsUpdatedAndCryptosPortfolio() async throws -> (Bool, [CryptoPortfolio])
    func addToMyPorfolio(this crypto: Crypto, with quantity: Float) async throws
}
