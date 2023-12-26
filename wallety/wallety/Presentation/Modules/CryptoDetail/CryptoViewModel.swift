//
//  CryptoViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 6/12/23.
//

import Foundation

class CryptoDetailViewModel: ObservableObject {
    @Published var crypto: Crypto
    @Published var cryptosPortfolio: [CryptoPortfolio] = []
    @Published var error: String = ""
    @Published var quantityText: String = "" {
        didSet {
            let quantityFormatted = quantityText.replacingOccurrences(of: ",", with: ".")
            if let quantity = Float(quantityFormatted) {
                self.quantityToAdd = quantity
            }
        }
    }
    @Published var priceText: String = "" {
        didSet {
            let priceFormatted = priceText.replacingOccurrences(of: ",", with: ".")
            if let price = Float(priceFormatted) {
                self.priceToAdd = price
            }
        }
    }
    @Published var total: String = "---"
    @Published var quantity: String = "---"

    private var priceToAdd: Float = 0.0
    private var quantityToAdd: Float = 0.0

    var portfolioUseCases: CryptoPortfolioUseCasesProtocol
    var rateUseCases: RatesUseCasesProtocol

    init(crypto: Crypto, portfolioUseCases: CryptoPortfolioUseCasesProtocol, rateUseCases: RatesUseCasesProtocol) {
        self.crypto = crypto
        self.portfolioUseCases = portfolioUseCases
        self.rateUseCases = rateUseCases
        self.priceText = "\(crypto.priceUsd)"
    }

    func load() {
        Task {
            let cryptosPortfolio = try await portfolioUseCases.getPortfolio(with: crypto.symbol)
            let rate = try await rateUseCases.getCurrentCurrency()
            crypto.currency = rate
            let (total, quantity) = try await portfolioUseCases.getTotalAndQuantityFormatted(of: cryptosPortfolio)
            await MainActor.run {
                self.cryptosPortfolio = cryptosPortfolio
                self.total = total
                self.quantity = quantity
            }
        }
    }

    func addToMyPortfolio() {
        Task {
            do {
                if quantityToAdd > 0 {
                    try await portfolioUseCases.addToMyPorfolio(this: crypto,
                                                                with: self.quantityToAdd,
                                                                and: priceToAdd)
                    load()
                    await MainActor.run {
                        self.priceText = "\(crypto.priceUsd)"
                    }
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }

    func delete(this portfolio: CryptoPortfolio) {
        Task {
            try await portfolioUseCases.delete(this: portfolio)
            load()
        }
    }
}
