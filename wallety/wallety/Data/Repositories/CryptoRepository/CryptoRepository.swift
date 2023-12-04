//
//  CryptoRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoRepository: CryptoRepositoryProtocol {
    var remoteDataSource: RemoteCryptoDataSourceProtocol

    init(remoteDataSource: RemoteCryptoDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func getTopCrypto() async throws -> [Crypto] {
        try await remoteDataSource.getTopCryptos().map({ $0.toDomain()})
    }
}


extension CryptoCoinCapDTO {
    func toDomain() -> Crypto {
        return Crypto(id: self.id,
                      symbol: self.symbol,
                      name: self.name,
                      priceUsd: Float(self.priceUsd) ?? 0.0)
    }
}
