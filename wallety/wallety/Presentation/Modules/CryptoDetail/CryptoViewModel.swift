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
    @Published var cryptoHistoryPrices: [CryptoHistory] = [] {
        didSet {
            let sortedCryptoHistoryPrices = cryptoHistoryPrices.sorted(by: {$0.priceUsd < $1.priceUsd})
            maxValueForChart = sortedCryptoHistoryPrices.last?.priceUsd ?? 0.0
            minValueForChart = sortedCryptoHistoryPrices.first?.priceUsd ?? 0.0
        }
    }
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
    @Published var minValueForChart: Float = 0.0
    @Published var maxValueForChart: Float = 0.0
    @Published var price: Float = 0.0

    private var priceToAdd: Float = 0.0
    private var quantityToAdd: Float = 0.0
    private var originalPrice: Float = 0.0

    var portfolioUseCases: CryptoPortfolioUseCasesProtocol
    var rateUseCases: RatesUseCasesProtocol
    var cryptoHistoryUseCases: CryptoHistoryUseCasesProtocol

    init(crypto: Crypto,
         portfolioUseCases: CryptoPortfolioUseCasesProtocol,
         rateUseCases: RatesUseCasesProtocol,
         cryptoHistoryUseCases: CryptoHistoryUseCasesProtocol) {
        self.crypto = crypto
        self.portfolioUseCases = portfolioUseCases
        self.rateUseCases = rateUseCases
        self.cryptoHistoryUseCases = cryptoHistoryUseCases
        self.priceText = "\(crypto.priceUsd)"
    }

    func load() {
        Task {
            let cryptosPortfolio = try await portfolioUseCases.getPortfolio(with: crypto.symbol)
            let rate = try await rateUseCases.getCurrentCurrency()
            let cryptoHistoryPrices = try await cryptoHistoryUseCases.getHistory(for: self.crypto.name).suffix(30)
            crypto.currency = rate
            let (total, quantity) = try await portfolioUseCases.getTotalAndQuantityFormatted(of: cryptosPortfolio)
            await MainActor.run {
                self.cryptosPortfolio = cryptosPortfolio
                self.cryptoHistoryPrices = Array(cryptoHistoryPrices)
                self.total = total
                self.quantity = quantity
                self.originalPrice = crypto.priceUsd
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

    func setOriginalPrice() {
        self.price = originalPrice
    }
}
