//
//  LocalCryptoPortfolioDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation

protocol LocalCryptoPortfolioDataSourceProtocol {
    func getCryptoPortfolio() async throws -> [CryptoPortfolioDBO]
    func getPortfolio(with symbol: String) async throws -> [CryptoPortfolioDBO]
    func addToMyPortfolio(this crypto: String,
                          symbol: String,
                          with quantity: Float,
                          and price: Float) async throws
    func delete(this portfolio: CryptoPortfolioDBO) async throws
}
