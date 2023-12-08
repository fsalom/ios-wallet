//
//  CryptoMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoMockUseCases: CryptoUseCasesProtocol {
    func getIsUpdatedAndCryptos() async throws -> (Bool, [Crypto]) {
        (false,
         [Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
          Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)
         ])
    }

    func getIsUpdatedAndCryptosPortfolio() async throws -> (Bool, [CryptoPortfolio]) {
        let crypto = Crypto(symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)

        return (false,
                [CryptoPortfolio(crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(crypto: crypto, quantity: 1.2),
                 CryptoPortfolio(crypto: crypto, quantity: 1.2)])
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float) async throws {
    }
}
