//
//  RemoteRatesDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

protocol RemoteRatesDataSourceProtocol {
    func getRateUsd(with currency: String) async throws -> RateDTO
    func getRatesUsd() async throws -> [RateDTO]
}
