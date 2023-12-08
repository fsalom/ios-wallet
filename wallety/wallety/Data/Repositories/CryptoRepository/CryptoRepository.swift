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

    func getIsUpdatedAndCryptos() async throws -> (Bool, [Crypto]) {
        let isUpdated = !shouldUpdate(for: .top)
        let cryptosDBO = try await localDataSource.getCryptos()
        if cryptosDBO.isEmpty || !isUpdated {
            let cryptosDTO = try await remoteDataSource.getTopCryptos()
            try await save(these: cryptosDTO.map({$0.toDBO()}))
            setDate(for: .top)
            return (true, cryptosDTO.map { $0.toDomain() })
        }
        return (false, cryptosDBO.map({$0.toDomain()}))
    }

    func getIsUpdatedAndCryptosPortfolio() async throws -> (Bool, [CryptoPortfolio]) {
        let isUpdated = !shouldUpdate(for: .portfolio)
        return (isUpdated,
                try await localDataSource.getCryptoPortfolio().map({$0.toDomain()}))
    }

    func addToMyPorfolio(this crypto: Crypto, with quantity: Float) async throws {
        guard let cryptoDBO = try await localDataSource.getCrypto(with: crypto.symbol) else {
            try await localDataSource.save(this: crypto.toDBO())
            try await addToMyPorfolio(this: crypto, with: quantity)
            return
        }

        try await localDataSource.addToMyPortfolio(this: cryptoDBO, with: quantity)
        setDate(for: .portfolio, isResetNeeded: true)
    }

    private func save(these cryptosDBO: [CryptoDBO]) async throws {
        try await localDataSource.save(these: cryptosDBO)
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
            case .top: return 3000
            case .portfolio: return 3000
            }
        }
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
                      priceUsd: Float(self.priceUsd) ?? 0.0)
    }

    func toDBO() -> CryptoDBO {
        return CryptoDBO(name: self.name,
                         symbol: self.symbol,
                         priceUsd: Float(self.priceUsd) ?? 0.0)
    }
}

fileprivate extension CryptoDBO {
    func toDomain() -> Crypto {
        return Crypto(symbol: self.symbol,
                      name: self.name,
                      priceUsd: self.priceUsd)
    }
}

fileprivate extension Crypto {
    func toDBO() -> CryptoDBO {
        return CryptoDBO(name: self.name,
                         symbol: self.symbol,
                         priceUsd: self.priceUsd)
    }
}

fileprivate extension CryptoPortfolioDBO {
    func toDomain() -> CryptoPortfolio {
        return CryptoPortfolio(crypto: Crypto(
            symbol: symbol,
            name: name,
            priceUsd: priceUsd),                               
            quantity: quantity)
    }
}
