//
//  CryptoMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoMockUseCases: CryptoUseCasesProtocol {
    func getCryptosWithoutFavorites(from cryptos: [Crypto]) async throws -> [Crypto] {
        []
    }
    
    func getFavoriteCryptos(from cryptos: [Crypto]) async throws -> [Crypto] {
        []
    }
    
    func filter(these cryptos: [Crypto], with text: String) -> [Crypto] {
        cryptos
    }

    func getTotal(with currency: Rate) async throws -> String {
        "40000"
    }
    
    func getCrypto(with symbol: String) async throws -> Crypto? {
        nil
    }
    

    func delete(this portfolio: CryptoPortfolio) async throws {
        
    }
    
    func getTotalAndQuantityFormatted(of cryptosPortfolio: [CryptoPortfolio]) async throws -> (String, String) {
        ("", "")
    }
    
    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio] {
        []
    }
    
    func getCryptos() async throws -> [Crypto] {
        [Crypto(symbol: "BTC",
                name: "Bitcoin",
                priceUsd: 45200.00,
                marketCapUsd: 0.0,
                changePercent24Hr: 2.0),
         Crypto(symbol: "BTC",
                 name: "Bitcoin",
                 priceUsd: 45200.00,
                 marketCapUsd: 0.0,
                 changePercent24Hr: 2.0)]
    }

    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        let crypto = Crypto(symbol: "BTC",
                            name: "Bitcoin",
                            priceUsd: 45200.00,
                            marketCapUsd: 0.0,
                            changePercent24Hr: 0.0)

        return [CryptoPortfolio(
            id: UUID().uuidString,
            crypto: crypto,
            quantity: 1.2,
            purchasePrice: 0.0,
            purchaseCurrency: "EUR")]
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) {
    }

    func update(these cryptos: [Crypto], with currency: Rate) -> [Crypto] {
        cryptos
    }

    func favOrUnfav(this symbol: String) async throws {        
    }
}
