//
//  CryptoHistoryMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

class CryptoHistoryMockUseCases: CryptoHistoryUseCasesProtocol {
    func get24HoursHistory(for crypto: String) async throws -> [CryptoHistory] {
        []
    }
    
    func getOneMonthHistory(for crypto: String) async throws -> [CryptoHistory] {
        []
    }
    
    func getTotalHistory(for cryptos: [CryptoPortfolio]) async throws -> [CryptoHistory] {
        []
    }
    

}
