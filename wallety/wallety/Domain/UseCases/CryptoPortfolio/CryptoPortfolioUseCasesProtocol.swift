//
//  CryptoPortfolioUseCasesProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/12/23.
//

import Foundation

protocol CryptoPortfolioUseCasesProtocol {
    func getCryptosPortfolio() async throws -> [CryptoPortfolio]
    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) async throws
    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolio]
    func getTotalPriceUsd() async throws -> Float
    func getTotalAndQuantityFormatted(of symbol: String) async throws -> (String, String)
    func getTotalFormattedWithCurrentCurrency(of totalUsd: Float) async throws -> String
    func delete(this portfolio: CryptoPortfolio) async throws
    func update(these cryptos: [CryptoPortfolio], with currency: Rate) -> [CryptoPortfolio]
    func update(these cryptos: [CryptoPortfolio], with crypto: Crypto) -> [CryptoPortfolio]
    func filter(these cryptos: [CryptoPortfolio], with text: String) -> [CryptoPortfolio]
}
