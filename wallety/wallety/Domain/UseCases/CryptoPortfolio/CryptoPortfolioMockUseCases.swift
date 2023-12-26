//
//  CryptoPortfolioMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation

class CryptoPortfolioMockUseCases: CryptoPortfolioUseCasesProtocol {
    func getTotal(of cryptosPorfolio: [CryptoPortfolio]) async throws -> String {
        ""
    }
    
    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        []
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) async throws {

    }

    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio] {
        []
    }

    func getTotalAndQuantityFormatted(of cryptosPortfolio: [CryptoPortfolio]) async throws -> (String, String) {
        ("","")
    }

    func delete(this portfolio: CryptoPortfolio) async throws { }

    func getTotal() async throws -> String {
        ""
    }
    
    func update(these cryptos: [CryptoPortfolio], with currency: Rate) -> [CryptoPortfolio] {
        cryptos
    }

    func filter(these cryptos: [CryptoPortfolio], with text: String) -> [CryptoPortfolio] {
        return cryptos
    }
}
