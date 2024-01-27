//
//  LocalCryptoPortfolioDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation

protocol LocalCryptoPortfolioDataSourceProtocol {
    func getCryptoPortfolio() async throws -> [CryptoPortfolioDBO]
    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolioDBO]
    func addToMyPortfolio(this crypto: String,
                          symbol: String,
                          rateId: String,
                          rateUsd: Float,
                          with quantity: Float,
                          and price: Float) async throws
    func delete(this id: String) async throws
}
