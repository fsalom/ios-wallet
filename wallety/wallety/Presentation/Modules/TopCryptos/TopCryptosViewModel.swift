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
    }

    @Published var cryptos: [Crypto] = []
    @Published var error: String = ""
    @Published var searchText: String = "" {
        didSet {
            filter(with: searchText)
        }
    }

    var originalCryptos: [Crypto] = []
    var cryptoUseCases: CryptoUseCasesProtocol
    var ratesUseCases: RatesUseCasesProtocol

    init(cryptoUseCases: CryptoUseCasesProtocol, ratesUseCases: RatesUseCasesProtocol) {
        self.cryptoUseCases = cryptoUseCases
        self.ratesUseCases = ratesUseCases
    }

    func load() async {
        do {
            let data = try await loadData()
            await MainActor.run {
                self.cryptos = data.cryptos
                self.originalCryptos = data.cryptos
            }
        } catch {
            self.error = "_ERROR_"
        }
    }

    private func loadData() async throws -> TopCryptoData  {
        async let cryptos = try await self.cryptoUseCases.getCryptos()
        async let currentCurrency = try await self.ratesUseCases.getCurrentCurrency()
        return try await TopCryptoData(
            cryptos: self.cryptoUseCases.update(these: cryptos, with: currentCurrency)
        )
    }

    private func filter(with text: String) {
        if text.isEmpty {
            self.cryptos = originalCryptos
        }else{
            self.cryptos = cryptoUseCases.filter(these: originalCryptos, with: text)
        }
    }
}
