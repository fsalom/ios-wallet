//
//  CryptoHistoryRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

class CryptoHistoryRepository: CryptoHistoryRepositoryProtocol {
    var localDataSource: LocalCryptoHistoryDataSourceProtocol
    var remoteDataSource: RemoteCryptoHistoryDataSourceProtocol

    init(localDataSource: LocalCryptoHistoryDataSourceProtocol,
         remoteDataSource: RemoteCryptoHistoryDataSourceProtocol) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    func getHistory(for crypto: String) async throws -> [CryptoHistory] {
        try await self.remoteDataSource.getHistory(for: crypto).map(
            { $0.toDomain() }
        )
    }
}

fileprivate extension CryptoHistoryDTO {
    func toDomain() -> CryptoHistory {
        CryptoHistory(time: time, priceUsd: Float(priceUsd) ?? 0.0)
    }
}
