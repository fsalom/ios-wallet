//
//  CryptoRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class CryptoRepository: CryptoRepositoryProtocol {
    var localDataSource: LocalCryptoDataSourceProtocol
    var remoteDataSource: RemoteCryptoDataSourceProtocol
    var updateInfoManager: UpdateInfoManagerProtocol

    let topKey = "CRYPTO_LAST_UPDATED_TOP"
    let portfolioKey = "CRYPTO_LAST_UPDATED_PORTFOLIO"
    let secondsToUpdate = 300

    init(localDataSource: LocalCryptoDataSourceProtocol,
         remoteDataSource: RemoteCryptoDataSourceProtocol,
         updateInfoManager: UpdateInfoManagerProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.updateInfoManager = updateInfoManager
    }

    func getCrypto(with symbol: String) async throws -> Crypto? {
        try await localDataSource.getCrypto(with: symbol)?.toDomain()
    }

    func getCryptos() async throws -> [Crypto] {
        let isUpdated = !updateInfoManager.shouldUpdate(this: topKey,
                                                        after: secondsToUpdate)
        let cryptosDBO = try await localDataSource.getCryptos()
        if cryptosDBO.isEmpty || !isUpdated {
            let cryptosDTO = try await remoteDataSource.getTopCryptos()
            try await localDataSource.deleteAll()
            Task(priority: .background) {
                try await localDataSource.save(these: cryptosDTO.map({$0.toDBO()}))
            }
            updateInfoManager.setDate(for: topKey,
                                      isResetNeeded: false)
            return try await setFavorites(for: cryptosDTO.map { $0.toDomain() })
        }

        return try await setFavorites(for: cryptosDBO.map { $0.toDomain() })
    }

    private func save(these cryptosDBO: [CryptoDBO]) async throws {
        Task(priority: .background) {
            try await localDataSource.save(these: cryptosDBO)
        }
    }

    func favOrUnfav(this symbol: String) async throws {
        try await localDataSource.favOrUnfav(this: symbol)
    }

    func getFavorites() async throws -> [Crypto]{
        var cryptos = try await getCryptos()
        cryptos = try await setFavorites(for: cryptos)
        cryptos = cryptos.filter({$0.isFavorite})
        cryptos.sort { $0.marketCapUsd > $1.marketCapUsd }
        return cryptos
    }
}

extension CryptoRepository {
    private func setFavorites(for cryptos: [Crypto]) async throws -> [Crypto] {
        var cryptosWithFavorite = [Crypto]()
        let favorites = try await localDataSource.getFavorites()
        let symbols = favorites.map { $0.symbol }
        for var crypto in cryptos {
            crypto.isFavorite = symbols.contains(crypto.symbol)
            cryptosWithFavorite.append(crypto)
        }
        return cryptosWithFavorite
    }
}

fileprivate extension CryptoCoinCapDTO {
    func toDomain() -> Crypto {
        return Crypto(symbol: self.symbol,
                      name: self.name,
                      priceUsd: Float(self.priceUsd) ?? 0.0,
                      marketCapUsd: Float(self.marketCapUsd) ?? 0.0,
                      changePercent24Hr: Float(changePercent24Hr) ?? 0.0)
    }

    func toDBO() -> CryptoDBO {
        return CryptoDBO(name: self.name,
                         symbol: self.symbol,
                         priceUsd: Float(self.priceUsd) ?? 0.0,
                         marketCapUsd: Float(self.marketCapUsd) ?? 0.0,
                         changePercent24Hr: Float(changePercent24Hr) ?? 0.0)
    }
}

fileprivate extension CryptoDBO {
    func toDomain() -> Crypto {
        return Crypto(symbol: self.symbol,
                      name: self.name,
                      priceUsd: self.priceUsd,
                      marketCapUsd: self.marketCapUsd ?? 0.0,
                      changePercent24Hr: self.changePercent24Hr ?? 0.0)
    }
}

fileprivate extension Crypto {
    func toDBO() -> CryptoDBO {
        return CryptoDBO(name: self.name,
                         symbol: self.symbol,
                         priceUsd: self.priceUsd,
                         marketCapUsd: self.marketCapUsd,
                         changePercent24Hr: self.changePercent24Hr)
    }
}

fileprivate extension CryptoPortfolioDBO {
    func toDomain() -> CryptoPortfolio {
        return CryptoPortfolio(
            id: id,
            crypto: Crypto(
                symbol: symbol,
                name: name,
                priceUsd: priceUsd,
                marketCapUsd: 0.0,
                changePercent24Hr: 0.0),
            quantity: quantity,
            purchasePrice: priceUsd,
            purchaseCurrency: rateId)
    }
}
