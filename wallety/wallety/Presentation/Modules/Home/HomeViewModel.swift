//
//  HomeViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

struct HomeData {
    var cryptos: [Crypto]
    var rates: [Rate]
    var total: String
    var currentCurrency: Rate
}

class HomeViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var rates: [Rate] = []
    @Published var total: String = "---"
    @Published var error: String = ""

    var cryptoUseCases: CryptoUseCasesProtocol
    var cryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol
    var ratesUseCases: RatesUseCasesProtocol
    private var currentCurrency: Rate

    init(cryptoUseCases: CryptoUseCasesProtocol,
         cryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol,
         ratesUseCases: RatesUseCasesProtocol) {
        self.cryptoUseCases = cryptoUseCases
        self.cryptoPortfolioUseCases = cryptoPortfolioUseCases
        self.ratesUseCases = ratesUseCases
        self.currentCurrency = Rate.default()
    }

    func load() {
        Task {
            do {
                let data = try await loadData()
                await MainActor.run {
                    self.cryptos = data.cryptos
                    self.rates = data.rates
                    self.total = data.total
                    self.currentCurrency = data.currentCurrency
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }

    func loadData() async throws -> HomeData {
        async let cryptos = try await getCryptos()
        async let total = try await getTotal()
        async let rates = try await getRates()
        async let currentCurrency = try await getCurrentCurrency()

        return try await HomeData(
            cryptos: cryptoUseCases.update(these: cryptos,
                                           with: currentCurrency),
            rates: rates,
            total: total,
            currentCurrency: currentCurrency)
    }

    func getCryptos() async throws -> [Crypto] {
        let cryptos = try await self.cryptoUseCases.getCryptos()
        return cryptos
    }

    func getRates() async throws -> [Rate] {
        return try await self.ratesUseCases.getFilteredCurrenciesRates()
    }

    func getTotal() async throws -> String {
        return try await self.cryptoPortfolioUseCases.getTotal()
    }

    func getCurrentCurrency() async throws -> Rate {
        return try await self.ratesUseCases.getCurrentCurrency()
    }
}
