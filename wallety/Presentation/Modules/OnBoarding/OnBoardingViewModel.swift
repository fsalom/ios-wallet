//
//  OnBoardingViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 26/12/23.
//

import Foundation

class OnBoardingViewModel: ObservableObject {
    struct Currency: Identifiable {
        var id: String = UUID().uuidString
        var icon: String
        var name: String
        var symbol: String
        var selected: Bool = false
    }

    @Published var cryptos: [Crypto] = []
    @Published var currencies: [Currency] = []
    @Published var rates: [Rate] = []
    @Published var error: String = ""
    @Published var searchText: String = "" {
        didSet {
            filter(with: searchText)
        }
    }

    var originalCryptos: [Crypto] = []
    var cryptoUseCases: CryptoUseCasesProtocol
    var ratesUseCases: RatesUseCasesProtocol
    var userUseCases: UserUseCasesProtocol

    init(cryptoUseCases: CryptoUseCasesProtocol, ratesUseCases: RatesUseCasesProtocol, userUseCases: UserUseCasesProtocol) {
        self.cryptoUseCases = cryptoUseCases
        self.ratesUseCases = ratesUseCases
        self.userUseCases = userUseCases
    }

    func load() {
        Task {
            do {
                let cryptos = try await self.cryptoUseCases.getCryptos()
                let rates = try await self.ratesUseCases.getFilteredCurrenciesRates()
                let currencies = getCurrencies()
                await MainActor.run {
                    self.cryptos = cryptos
                    self.originalCryptos = cryptos
                    self.currencies = currencies
                    self.rates = rates
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }

    func save(name: String) {
        Task {
            do {
                try await self.userUseCases.save(name: name)
            } catch {
                self.error = "_ERROR_"
            }
        }
    }

    func getCurrencies() -> [Currency] {
        return [Currency(icon: "dollarsign.circle",
                         name: "Dollar",
                         symbol: "USD",
                         selected: true),
                Currency(icon: "eurosign.circle",
                         name: "Euro",
                         symbol: "EUR"),
                Currency(icon: "sterlingsign.circle",
                         name: "Libra",
                         symbol: "GBP")]
    }

    func filter(with text: String) {
        if text.isEmpty {
            self.cryptos = originalCryptos
        }else{
            self.cryptos = cryptoUseCases.filter(these: originalCryptos, with: text)
        }
    }

    func select(this currency: Currency) {
        var currentCurrencies: [Currency] = []
        for var _currency in currencies {
            _currency.selected = _currency.name == currency.name ? true : false
            currentCurrencies.append(_currency)
        }
        self.currencies = currentCurrencies
        guard let selectedCurrency = currencies.first(
            where: {$0.selected == true}
        ) else { return }
        self.updateCryptos(with: selectedCurrency)
    }

    func updateCryptos(with currency: Currency) {
        Task {
            guard let selectedRate = self.ratesUseCases.getCurrency(
                from: self.rates, with: currency.symbol)
            else { return }
            try await self.ratesUseCases.select(this: selectedRate)
            let cryptos = self.cryptoUseCases.update(these: self.cryptos, with: selectedRate)
            await MainActor.run {
                self.cryptos = cryptos
            }
        }
    }

    func favOrUnfav(this crypto: Crypto) {
        Task {
            try await self.cryptoUseCases.favOrUnfav(this: crypto.symbol)
            if let index = self.cryptos.firstIndex(where: {$0.id == crypto.id}) {
                await MainActor.run {
                    self.cryptos[index].isFavorite.toggle()
                    self.cryptos = self.cryptos
                }
            }
        }
    }
}
