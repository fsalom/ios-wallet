//
//  LocalRatesDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

protocol LocalRatesDataSourceProtocol {
    func getRateUsd(with id: String) async throws -> RateDBO?
    func getRatesUsd() async throws -> [RateDBO]
    func save(these rates: [RateDBO]) async throws
}
