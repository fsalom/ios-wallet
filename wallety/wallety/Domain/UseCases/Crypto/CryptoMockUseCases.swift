//
//  CryptoMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoMockUseCases: CryptoUseCasesProtocol {
    func getTopCryptos() async throws -> [Crypto] {
        [Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
         Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
         Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)
        ]
    }

    func getMyCryptos() async throws -> [Crypto] {
        [Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
         Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
         Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)
        ]
    }
}
