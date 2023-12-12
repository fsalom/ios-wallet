//
//  CryptoUseCaseProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol CryptoUseCasesProtocol {
    func getCrypto(with symbol: String) async throws -> Crypto?
    func getCryptos() async throws -> [Crypto]
    func getCryptosPortfolio() async throws -> [CryptoPortfolio]
    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) async throws
    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio]
    func getTotalAndQuantityFormatted(of cryptosPortfolio: [CryptoPortfolio]) async throws -> (String, String)
    func delete(this portfolio: CryptoPortfolio) async throws
    func getTotal(with currency: Rate) async throws -> String
}
