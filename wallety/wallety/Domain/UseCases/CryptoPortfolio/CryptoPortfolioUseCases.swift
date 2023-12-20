//
//  CryptoPortfolioUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/12/23.
//

import Foundation

class CryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol {
    let cryptoPortfolioRepository: CryptoPortfolioRepositoryProtocol
    let cryptoRepository: CryptoRepositoryProtocol

    init(cryptoPortfolioRepository: CryptoPortfolioRepositoryProtocol, cryptoRepository: CryptoRepositoryProtocol) {
        self.cryptoPortfolioRepository = cryptoPortfolioRepository
        self.cryptoRepository = cryptoRepository
    }

    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        let cryptosPortfolio = try await cryptoPortfolioRepository.getCryptosPortfolio()
        var myCryptosPortolio: [CryptoPortfolio] = []
        for portfolio in cryptosPortfolio {
            guard let index = myCryptosPortolio.firstIndex(
                where: {$0.crypto.symbol == portfolio.crypto.symbol}
            ) else {
                myCryptosPortolio.append(portfolio)
                continue
            }
            myCryptosPortolio[index].quantity += portfolio.quantity
        }
        return myCryptosPortolio
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) async throws {
        try await cryptoPortfolioRepository.addToMyPorfolio(
            this: crypto.name,
            symbol: crypto.symbol,
            with: quantity,
            and: price)
    }

    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio] {
        try await cryptoPortfolioRepository.getPortfolio(with: symbol)
    }

    func getTotalAndQuantityFormatted(of cryptosPortfolio: [CryptoPortfolio]) async throws -> (String, String) {
        guard let currentCrypto = try await cryptoRepository.getCrypto(with: cryptosPortfolio.first?.crypto.symbol ?? "") else {
            return ("---", "---")
        }

        var total: Float = 0.0
        var quantity: Float = 0.0
        for cryptoPortfolio in cryptosPortfolio {
            total += (cryptoPortfolio.quantity * currentCrypto.priceUsd)
            quantity += cryptoPortfolio.quantity
        }
        let totalFormatted = "$\(format(this: total) ?? "-")"
        let quantityFormatted = "\(quantity)"
        return (totalFormatted, quantityFormatted)
    }

    func delete(this portfolio: CryptoPortfolio) async throws {
        try await cryptoPortfolioRepository.delete(this: portfolio)
    }

    func getTotal(with currency: Rate = Rate.default()) async throws -> String {
        let cryptosPortfolio = try await getCryptosPortfolio()
        var total: Float = 0.0
        for cryptoPortfolio in cryptosPortfolio {
            let currentCrypto = try await cryptoRepository.getCrypto(with: cryptoPortfolio.crypto.symbol)
            guard let currentCrypto else {
                return "missing crypto"
            }
            total += cryptoPortfolio.quantity * (currentCrypto.priceUsd/currency.rateUsd)
        }
        guard let priceFormatted = format(this: total) else { return "bad format" }
        return currency.currencySymbol + priceFormatted
    }
}

extension CryptoPortfolioUseCases {
    private func format(this price: Float) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = "."
        let number = NSNumber(value: price)
        return formatter.string(from: number)
    }
}
