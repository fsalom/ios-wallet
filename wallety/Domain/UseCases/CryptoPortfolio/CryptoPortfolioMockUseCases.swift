//
//  CryptoPortfolioMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation

class CryptoPortfolioMockUseCases: CryptoPortfolioUseCasesProtocol {
    func getTotalFormattedWithCurrentCurrency(of total: Float) async throws -> String {
        ""
    }
    
    func getTotalPriceUsd() async throws -> Float {
        0.0
    }
    
    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        []
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) async throws {

    }

    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolio] {
        []
    }

    func getTotalAndQuantityFormatted(of symbol: String) async throws -> (String, String) {
        ("","")
    }

    func delete(this portfolio: CryptoPortfolio) async throws { }

    func getTotal() async throws -> String {
        ""
    }
    
    func update(these cryptos: [CryptoPortfolio], with currency: Rate) -> [CryptoPortfolio] {
        cryptos
    }

    func update(these cryptos: [CryptoPortfolio], with crypto: Crypto) -> [CryptoPortfolio] {
        []
    }

    func filter(these cryptos: [CryptoPortfolio], with text: String) -> [CryptoPortfolio] {
        return cryptos
    }
}
