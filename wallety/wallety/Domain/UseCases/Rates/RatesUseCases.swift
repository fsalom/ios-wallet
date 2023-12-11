//
//  RatesUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/12/23.
//

import Foundation

class RatesUseCases: RatesUseCasesProtocol {
    let repository: RatesRepositoryProtocol
    let filteredCurrencies = ["EUR", "GBP", "USD", "JPY"]

    init(repository: RatesRepositoryProtocol) {
        self.repository = repository
    }

    func getAllCurrenciesRates() async throws -> [Rate] {
        try await repository.getRates()
    }

    func getFilteredCurrenciesRates() async throws -> [Rate] {
        let currencies = try await repository.getRates()
        return currencies.filter({ filteredCurrencies.contains($0.symbol) })
    }

    func getCurrency(with id: String) async throws -> Rate? {
        try await repository.getRate(with: id)
    }

    func getCurrentCurrency() async throws -> Rate {
        try await repository.getCurrentCurrency()
    }
}
