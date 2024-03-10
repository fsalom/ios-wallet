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
    let ratesRepository: RatesRepositoryProtocol

    init(cryptoPortfolioRepository: CryptoPortfolioRepositoryProtocol,
         cryptoRepository: CryptoRepositoryProtocol,
         ratesRepository: RatesRepositoryProtocol) {
        self.cryptoPortfolioRepository = cryptoPortfolioRepository
        self.cryptoRepository = cryptoRepository
        self.ratesRepository = ratesRepository
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
            rateId: crypto.currency.identifier,
            rateUsd: crypto.currency.rateUsd,
            with: quantity,
            and: price)
    }

    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolio] {
        try await cryptoPortfolioRepository.getPortfolios(with: symbol)
    }

    func getTotalAndQuantityFormatted(of symbol: String) async throws -> (String, String) {
        guard let crypto = try await cryptoRepository.getCrypto(with: symbol) else {
            throw CryptoPortfolioError.notFound
        }
        let cryptoPortfolio = try await getPortfolios(with: symbol)
        let quantity: Float = cryptoPortfolio.compactMap({$0.quantity}).reduce(0, +)
        let totalUsd = quantity * crypto.priceUsd
        let totalFormatted = try await getTotalFormattedWithCurrentCurrency(of: totalUsd)
        let quantityFormatted = "\(quantity)"
        return (totalFormatted, quantityFormatted)
    }

    func delete(this portfolio: CryptoPortfolio) async throws {
        try await cryptoPortfolioRepository.delete(this: portfolio)
    }

    func getTotalPriceUsd() async throws -> Float {
        return try await calculateCurrentTotalInUsd()
    }

    func getTotalFormattedWithCurrentCurrency(of totalUsd: Float) async throws -> String {
        return try await getTotalFormattedWithCurrentCurrency(with: totalUsd)
    }

    func update(these cryptos: [CryptoPortfolio], with currency: Rate) -> [CryptoPortfolio] {
        var updatedCryptos: [CryptoPortfolio] = []
        cryptos.forEach { crypto in
            crypto.currency = currency
            updatedCryptos.append(crypto)
        }
        return updatedCryptos
    }

    func update(these cryptos: [CryptoPortfolio], with crypto: Crypto) -> [CryptoPortfolio] {
        var updatedCryptos: [CryptoPortfolio] = []
        cryptos.forEach { cryptoPortfolio in
            cryptoPortfolio.crypto = crypto
            updatedCryptos.append(cryptoPortfolio)
        }
        return updatedCryptos
    }

    func filter(these cryptos: [CryptoPortfolio], with text: String) -> [CryptoPortfolio] {
        return cryptos.filter({$0.crypto.name.lowercased().contains(text.lowercased())})
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

    private func calculateCurrentTotalInUsd() async throws -> Float {
        let cryptosPortfolio = try await cryptoPortfolioRepository.getCryptosPortfolio()
        var totalUsd: Float = 0.0
        for cryptoPortfolio in cryptosPortfolio {
            let currentCrypto = try await cryptoRepository.getCrypto(with: cryptoPortfolio.crypto.symbol)
            guard let currentCrypto else {
                throw CryptoPortfolioError.incompleted
            }
            totalUsd += cryptoPortfolio.quantity * (currentCrypto.priceUsd)
        }
        return totalUsd
    }

    func getTotalFormattedWithCurrentCurrency(with total: Float) async throws -> String {
        let currency = try await ratesRepository.getCurrentCurrency()
        let totalWithCurrency = total / currency.rateUsd
        guard let totalFormatted = format(this: totalWithCurrency) else { throw CryptoPortfolioError.badFormat }
        return currency.currencySymbol + totalFormatted
    }

    enum CryptoPortfolioError: Error {
        case notFound
        case incompleted
        case badFormat
    }
}
