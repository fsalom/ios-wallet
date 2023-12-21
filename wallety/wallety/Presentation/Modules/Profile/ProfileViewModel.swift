//
//  ProfileViewmodel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import Foundation

struct ProfileData {
    var currencies: [Rate]
    var currentCurrency: Rate
}

class ProfileViewModel: ObservableObject {

    var useCase: RatesUseCasesProtocol
    @Published var currentCurrency: Rate = Rate.default()
    @Published var currencies: [Rate] = []
    @Published var errorMessage: String = ""

    init(useCase: RatesUseCasesProtocol) {
        self.useCase = useCase
    }

    func load() {
        Task {
            let data = try await loadData()
            await MainActor.run {
                self.currencies = data.currencies
                self.currentCurrency = data.currentCurrency
            }
        }
    }

    func loadData() async throws -> ProfileData {
        async let currencies = try await useCase.getFilteredCurrenciesRates()
        async let currentCurrency = try await useCase.getCurrentCurrency()
        return try await ProfileData(
            currencies: currencies,
            currentCurrency: currentCurrency)
    }

    func select(this currency: Rate) {
        currentCurrency = currency
        save(this: currency)
    }

    private func save(this currency: Rate) {
        Task {
            do {
                try await self.useCase.select(this: currency)
            } catch {
                self.errorMessage = "_ERROR_"
            }
        }
    }

    func clearDB() {
        Task {
            
        }
    }
}
