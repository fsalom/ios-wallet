//
//  CryptoMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoMockUseCases: CryptoUseCasesProtocol {
    
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
         [Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)]
    }

    func getCryptosPortfolio() async throws -> [CryptoPortfolio] {
        let crypto = Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)

        return [CryptoPortfolio(id: UUID(), crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(id: UUID(), crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(id: UUID(), crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(id: UUID(), crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(id: UUID(), crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(id: UUID(), crypto: crypto, quantity: 1.2)]
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float, and price: Float) {
    }
}
