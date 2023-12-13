//
//  RatesRepositoryProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

protocol RatesRepositoryProtocol {
    func getRates() async throws -> [Rate]
    func getRate(with id: String) async throws -> Rate?
    func getCurrentCurrency() async throws -> Rate
    func save(selected currency: Rate) async throws
}
