//
//  CryptoPortfolioRespositoryProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 19/12/23.
//

import Foundation

protocol CryptoPortfolioRepositoryProtocol {
    func getCryptosPortfolio() async throws -> [CryptoPortfolio]
    func getPortfolios(with symbol: String) async throws -> [CryptoPortfolio]
    func delete(this portfolio: CryptoPortfolio) async throws
    func addToMyPorfolio(
        this crypto: String,
        symbol: String,
        rateId: String,
        rateUsd: Float,
        with quantity: Float,
        and price: Float) async throws
}
