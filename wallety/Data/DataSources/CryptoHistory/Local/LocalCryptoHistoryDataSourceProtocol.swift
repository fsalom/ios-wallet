//
//  LocalCryptoHistoryDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

protocol LocalCryptoHistoryDataSourceProtocol {
    func getHistory(for crypto: String) async throws -> [CryptoHistoryDBO]
    func save(this history: CryptoHistoryDBO)
}
