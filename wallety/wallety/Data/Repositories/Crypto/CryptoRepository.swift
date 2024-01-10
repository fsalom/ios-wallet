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
    var cacheManager: CacheManagerProtocol

    init(localDataSource: LocalCryptoDataSourceProtocol,
         remoteDataSource: RemoteCryptoDataSourceProtocol,
         cacheManager: CacheManagerProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.cacheManager = cacheManager
    }

    func getCrypto(with symbol: String) async throws -> Crypto? {
        try await localDataSource.getCrypto(with: symbol)?.toDomain()
    }

    func getCryptos() async throws -> [Crypto] {
        let isUpdated = !shouldUpdate(for: .top)
        let cryptosDBO = try await localDataSource.getCryptos()
        if cryptosDBO.isEmpty || !isUpdated {
            let cryptosDTO = try await remoteDataSource.getTopCryptos()
            try await localDataSource.deleteAll()
            try await localDataSource.save(these: cryptosDTO.map({$0.toDBO()}))
            setDate(for: .top)
            return try await setFavorites(for: cryptosDTO.map { $0.toDomain() })
        }
        return try await setFavorites(for: cryptosDBO.map { $0.toDomain() })
    }

    private func save(these cryptosDBO: [CryptoDBO]) async throws {
        try await localDataSource.save(these: cryptosDBO)
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
    enum LastUpdatedOption {
        case top
        case portfolio

        var key: String {
            switch self {
            case .top: return "CRYPTO_LAST_UPDATED_TOP"
            case .portfolio: return "CRYPTO_LAST_UPDATED_PORTFOLIO"
            }
        }

        var seconds: Int {
            switch self {
            case .top: return 30
            case .portfolio: return 30
            }
        }
    }

    private func setFavorites(for cryptos: [Crypto]) async throws -> [Crypto] {
        var cryptosWithFavorite = cryptos
        let favorites = try await localDataSource.getFavorites().flatMap({$0.symbol})
        for crypto in cryptosWithFavorite {
            crypto.isFavorite = favorites.contains(crypto.symbol) ? true : false
        }
        return cryptosWithFavorite
    }

    private func shouldUpdate(for option: LastUpdatedOption) -> Bool {
        guard let lastUpdated = getDate(for: option) else {
            return true
        }
        let elapsed = Date.now.timeIntervalSince(lastUpdated)
        return Int(elapsed) > option.seconds ? true : false
    }

    private func getDate(for option: LastUpdatedOption) -> Date? {
        let lastUpdatedInfo = cacheManager.retrieve(
            objectFor: option.key,
            of: CryptoUpdatedDTO.self
        )
        return lastUpdatedInfo?.lastUpdated
    }

    private func setDate(for option: LastUpdatedOption, isResetNeeded: Bool = false) {
        let lastUpdatedInfo = CryptoUpdatedDTO(
            lastUpdated: isResetNeeded ? .distantPast : .now
        )
        cacheManager.save(objectFor: option.key, this: lastUpdatedInfo)
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
        return CryptoPortfolio(crypto: Crypto(
            symbol: symbol,
            name: name,
            priceUsd: priceUsd,
            marketCapUsd: 0.0,
            changePercent24Hr: 0.0),
            quantity: quantity)
    }
}
