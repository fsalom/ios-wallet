//
//  RatesMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/12/23.
//

import Foundation

class RatesMockUseCases: RatesUseCasesProtocol {
    func getFormattedWithCurrentCurrency(this price: Float) async throws -> String {
        ""
    }
    
    func select(this currency: Rate) async throws {
        
    }
    
    func getFilteredCurrenciesRates() async throws -> [Rate] {
        []
    }
    
    func getAllCurrenciesRates() async throws -> [Rate] {
        []
    }
    
    func getCurrency(with id: String) async throws -> Rate? {
        nil
    }

    func getCurrency(from rates: [Rate], with symbol: String) -> Rate? {
        nil
    }

    func getCurrentCurrency() async throws -> Rate {
        return Rate.default()
    }
}
