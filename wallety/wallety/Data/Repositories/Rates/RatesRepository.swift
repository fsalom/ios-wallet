//
//  RatesRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

class RatesRepository: RatesRepositoryProtocol {
    let localDataSource: LocalRatesDataSourceProtocol
    let remoteDataSource: RemoteRatesDataSourceProtocol

    init(localDataSource: LocalRatesDataSourceProtocol, remoteDataSource: RemoteRatesDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func getRates() async throws -> [Rate] {
        try await remoteDataSource.getRatesUsd().map({$0.toDomain()})
    }
    
    func getRate(with id: String) async throws -> Rate? {
        if let rate = try await remoteDataSource.getRateUsd(with: id) {
            return rate.toDomain()
        }
        return nil
    }

    func getCurrentCurrency() async throws -> Rate {
        guard let currentCurrency = try await localDataSource.getSelectedRate() else {
            return Rate.default()
        }
        return currentCurrency.toDomain()
    }

    func save(selected currency: Rate) async throws {
        try await localDataSource.save(selected: currency.toDBO())
    }

    func save(these currencies: [Rate]) async throws {
        try await localDataSource.save(these: currencies.map({$0.toDBO()}))
    }

}

fileprivate extension RateDTO {
    func toDomain() -> Rate {
        Rate(uid: UUID().uuidString,
             identifier: id,
             currencySymbol: currencySymbol ?? "-",
             symbol: symbol,
             rateUsd: Float(rateUsd) ?? 0.0)
    }
}

fileprivate extension RateDBO {
    func toDomain() -> Rate {
        Rate(uid: uid.uuidString,
             identifier: identifier,
             currencySymbol: currencySymbol,
             symbol: symbol,
             rateUsd: rateUsd)
    }
}

fileprivate extension Rate {
    func toDBO() -> RateDBO {
        RateDBO(identifier: identifier,
                createdAt: .now,
                currencySymbol: currencySymbol,
                symbol: symbol,
                rateUsd: rateUsd)
    }
}
