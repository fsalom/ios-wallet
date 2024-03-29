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
        let repository = CryptoRepository(
            localDataSource: localDataSource,
            remoteDataSource: networkDataSource,
            updateInfoManager: UpdateInfoUDManager(storage: UserDefaultsManager()))

        let portfolioLocalDataSource = DBCryptoPortfolioDataSource(
            with: container)
        let cryptoPortfolioRepository = CryptoPortfolioRepository(
            localDataSource: portfolioLocalDataSource)
        let ratesLocalDataSource = DBRatesDataSource(with: container)
        let ratesRemoteDataSource = CoincapRatesDataSource(networkManager: NetworkManager())
        let ratesCacheDataSource = UDRatesDataSource(with: UserDefaultsManager())
        let ratesRepository = RatesRepository(localDataSource: ratesLocalDataSource,
                                              remoteDataSource: ratesRemoteDataSource,
                                              cacheDataSource: ratesCacheDataSource)
        let portfolioUseCases = CryptoPortfolioUseCases(
            cryptoPortfolioRepository: cryptoPortfolioRepository,
            cryptoRepository: repository, 
            ratesRepository: ratesRepository)

        let rateUseCases = RatesUseCases(repository: ratesRepository)

        let remoteHistoryDataSource = RemoteCoincapHistoryDataSource(networkManager: NetworkManager())
        let localHistoryDataSource = DBCryptoHistoryDataSource(with: container)
        let historyRepository = CryptoHistoryRepository(localDataSource: localHistoryDataSource, remoteDataSource: remoteHistoryDataSource)
        let historyUseCases = CryptoHistoryUseCase(repository: historyRepository)
        
        let cryptoUseCases = CryptoUseCases(repository: repository)

        let viewModel = CryptoDetailViewModel(crypto: crypto,
                                              portfolioUseCases: portfolioUseCases,
                                              rateUseCases: rateUseCases,
                                              cryptoHistoryUseCases: historyUseCases,
                                              cryptoUseCases: cryptoUseCases)
        let view = CryptoDetailView(VM: viewModel)
        return view
    }
}
