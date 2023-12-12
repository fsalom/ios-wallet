//
//  CryptoUseCase.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoUseCases: CryptoUseCasesProtocol {
    let repository: CryptoRepositoryProtocol

    init(repository: CryptoRepositoryProtocol) {
        self.repository = repository
    }

    func getCrypto(with symbol: String) async throws -> Crypto? {
        try await repository.getCrypto(with: symbol)
    }

    func getCryptos() async throws -> [Crypto] {
        try await repository.getCryptos()
    }

    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        let cryptosPortfolio = try await repository.getCryptosPortfolio()
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
        try await repository.addToMyPorfolio(this: crypto, with: quantity, and: price)
    }

    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio] {
        try await repository.getPortfolio(with: symbol)
    }

    func getTotalAndQuantityFormatted(of cryptosPortfolio: [CryptoPortfolio]) async throws -> (String, String) {
        guard let currentCrypto = try await self.getCrypto(with: cryptosPortfolio.first?.crypto.symbol ?? "") else {
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
        try await repository.delete(this: portfolio)
    }

    func getTotal(with currency: Rate = Rate.default()) async throws -> String {
        let cryptosPortfolio = try await getCryptosPortfolio()
        var total: Float = 0.0
        for cryptoPortfolio in cryptosPortfolio {
            let currentCrypto = try await getCrypto(with: cryptoPortfolio.crypto.symbol)
            guard let currentCrypto else {
                return "missing crypto"
            }
            total += cryptoPortfolio.quantity * (currentCrypto.priceUsd/currency.rateUsd)
        }
        guard let priceFormatted = format(this: total) else { return "bad format" }
        return currency.currencySymbol + priceFormatted
    }
}

extension CryptoUseCases {
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
