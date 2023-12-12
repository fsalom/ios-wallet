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
    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolio]
    func delete(this portfolio: CryptoPortfolio) async throws
}
