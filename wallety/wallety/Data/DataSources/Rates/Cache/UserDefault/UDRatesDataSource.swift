//
//  UserDefaultsRateDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 13/12/23.
//

import Foundation

class UDRatesDataSource: CacheRatesDataSourceProtocol {
    private var cache: CacheManagerProtocol

    private var currentCurrencyRateKey = "_CURRENT_CURRENCY_RATE_"

    init(with cache: CacheManagerProtocol) {
        self.cache = cache
    }

    func save(selected rate: CacheRateDTO) async throws {
        self.cache.save(objectFor: currentCurrencyRateKey, this: rate)
    }

    func getSelectedRate() async throws -> CacheRateDTO? {
        self.cache.retrieve(objectFor: currentCurrencyRateKey, of: CacheRateDTO.self)
    }
}
