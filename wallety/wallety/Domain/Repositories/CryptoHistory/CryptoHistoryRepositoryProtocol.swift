//
//  CryptoHistoryRepositoryProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

protocol CryptoHistoryRepositoryProtocol {
    func getHistoryByHour(for crypto: String) async throws -> [CryptoHistory]
    func getHistoryByDay(for crypto: String) async throws -> [CryptoHistory]
}
