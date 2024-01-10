//
//  RemoteCryptoHistoryDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

protocol RemoteCryptoHistoryDataSourceProtocol {
    func getHistoryByDays(for crypto: String) async throws -> [CryptoHistoryDTO]
    func getHistoryByHours(for crypto: String) async throws -> [CryptoHistoryDTO]
}
