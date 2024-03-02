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

    func getCurrency(from rates: [Rate], with symbol: String) -> Rate? {
        return rates.first(where: {$0.symbol == symbol})
    }

    func getCurrentCurrency() async throws -> Rate {
        try await repository.getCurrentCurrency()
    }

    func select(this currency: Rate) async throws {
        try await repository.save(selected: currency)
    }

    func getFormattedWithCurrentCurrency(this price: Float) async throws -> String {
        let currentCurrency = try await getCurrentCurrency()
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: price/currentCurrency.rateUsd)
        return "\(currentCurrency.currencySymbol)\(formatter.string(from: number) ?? "-")"
    }
}
