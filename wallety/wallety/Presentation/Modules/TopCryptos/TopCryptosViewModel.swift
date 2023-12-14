//
//  TopCryptosViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class TopCryptosViewModel: ObservableObject {
    struct TopCryptoData {
        var cryptos: [Crypto]
        var rate: Rate
    }

    @Published var cryptos: [Crypto] = []
    @Published var error: String = ""
    @Published var searchText: String = ""

    var cryptoUseCases: CryptoUseCasesProtocol
    var ratesUseCases: RatesUseCasesProtocol

    init(cryptoUseCases: CryptoUseCasesProtocol, ratesUseCases: RatesUseCasesProtocol) {
        self.cryptoUseCases = cryptoUseCases
        self.ratesUseCases = ratesUseCases
    }

    func load() {
        Task {
            do {
                let data = try await loadData()
                await MainActor.run {
                    self.cryptos = updateCurrency(for: data.cryptos, with: data.rate)
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }

    private func loadData() async throws -> TopCryptoData  {
        async let cryptos = try await self.cryptoUseCases.getCryptos()
        async let currentCurrency = try await self.ratesUseCases.getCurrentCurrency()
        return try await TopCryptoData(
            cryptos: cryptos,
            rate: currentCurrency)
    }

    private func updateCurrency(for cryptos: [Crypto], with currency: Rate) -> [Crypto] {
        var updatedCryptos: [Crypto] = []
        cryptos.forEach { crypto in
            crypto.currency = currency
            updatedCryptos.append(crypto)
        }
        return cryptos
    }
}
