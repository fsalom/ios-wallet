//
//  LocalCoinDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 3/12/23.
//

import Foundation

protocol LocalCryptoDataSourceProtocol {
    func save(these cryptos: [CryptoDBO])  async throws
    func getCryptos()  async throws -> [CryptoDBO]
}
