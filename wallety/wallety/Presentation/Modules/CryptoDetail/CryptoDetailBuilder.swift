//
//  CryptoDetailBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 6/12/23.
//

import Foundation
import SwiftData

class CryptoDetailBuilder {
    func build(with crypto: Crypto, and container: ModelContainer) -> CryptoDetailView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())
        let localDataSource = DBCryptoDataSource(with: container)
        let repository = CryptoRepository(localDataSource: localDataSource,
                                          remoteDataSource: networkDataSource,
                                          cacheManager: UserDefaultsManager())

        let portfolioLocalDataSource = DBCryptoPortfolioDataSource(
            with: container)
        let cryptoPortfolioRepository = CryptoPortfolioRepository(
            localDataSource: portfolioLocalDataSource)
        let useCase = CryptoPortfolioUseCases(
            cryptoPortfolioRepository: cryptoPortfolioRepository,
            cryptoRepository: repository)

        let viewModel = CryptoDetailViewModel(crypto: crypto, useCase: useCase)
        let view = CryptoDetailView(VM: viewModel)
        return view
    }
}
