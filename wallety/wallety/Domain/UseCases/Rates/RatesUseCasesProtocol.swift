//
//  RatesUseCasesProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/12/23.
//

import Foundation

protocol RatesUseCasesProtocol {
    func getAllCurrenciesRates() async throws -> [Rate]
    func getCurrency(with id: String) async throws -> Rate?
    func getCurrency(from rates: [Rate], with symbol: String) -> Rate?
    func getCurrentCurrency() async throws -> Rate
    func getFilteredCurrenciesRates() async throws -> [Rate]
    func select(this currency: Rate) async throws
}

