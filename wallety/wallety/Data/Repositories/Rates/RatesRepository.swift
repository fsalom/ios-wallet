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
        try await remoteDataSource.getRateUsd(with: id).toDomain()
    }
}

fileprivate extension RateDTO {
    func toDomain() -> Rate {
        Rate(uid: UUID().uuidString,
             identifier: id,
             currencySymbol: currencySymbol,
             symbol: symbol,
             rateUsd: Float(rateUsd) ?? 0.0)
    }
}
