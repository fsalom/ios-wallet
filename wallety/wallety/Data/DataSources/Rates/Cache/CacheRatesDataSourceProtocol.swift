//
//  CacheRatesDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 13/12/23.
//

import Foundation

protocol CacheRatesDataSourceProtocol {
    func save(selected rate: CacheRateDTO) async throws
    func getSelectedRate() async throws -> CacheRateDTO?
}
