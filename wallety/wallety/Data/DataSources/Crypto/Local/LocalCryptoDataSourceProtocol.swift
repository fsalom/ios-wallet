//
//  LocalCoinDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 3/12/23.
//

import Foundation

protocol LocalCryptoDataSourceProtocol {
    func save(these cryptos: [CryptoDBO])  async throws
    func save(this crypto: CryptoDBO)  async throws
    func getCryptos() async throws -> [CryptoDBO]
    func getCrypto(with symbol: String) async throws -> CryptoDBO?
    func getCryptoPortfolio() async throws -> [CryptoPortfolioDBO]
    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolioDBO]
    func addToMyPortfolio(this crypto: CryptoDBO, with quantity: Float, and price: Float) async throws
    func delete(this id: UUID) async throws
}
