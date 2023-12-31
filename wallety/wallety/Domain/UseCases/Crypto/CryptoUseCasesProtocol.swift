//
//  CryptoUseCaseProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol CryptoUseCasesProtocol {
    func getCrypto(with symbol: String) async throws -> Crypto?
    func getCryptos() async throws -> [Crypto]
    func getCryptosWithoutFavorites(from cryptos: [Crypto]) async throws -> [Crypto]
    func update(these cryptos: [Crypto], with currency: Rate) -> [Crypto]
    func filter(these cryptos: [Crypto], with text: String) -> [Crypto]
    func getFavoriteCryptos(from cryptos: [Crypto]) async throws -> [Crypto]
    func favOrUnfav(this symbol: String) async throws
}
