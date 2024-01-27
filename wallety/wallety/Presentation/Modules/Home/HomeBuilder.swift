//
//  HomeBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftData

class HomeBuilder {
    func build(with container: ModelContainer) -> HomeView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())
        let localDataSource = DBCryptoDataSource(with: container)
        let repository = CryptoRepository(
            localDataSource: localDataSource,
            remoteDataSource: networkDataSource,
            updateInfoManager: UpdateInfoUDManager(storage: UserDefaultsManager()))
        let cryptoUseCases = CryptoUseCases(repository: repository)

        let ratesLocalDataSource = DBRatesDataSource(with: container)
        let ratesRemoteDataSource = CoincapRatesDataSource(networkManager: NetworkManager())
        let ratesCacheDataSource = UDRatesDataSource(with: UserDefaultsManager())
        let ratesRepository = RatesRepository(localDataSource: ratesLocalDataSource,
                                              remoteDataSource: ratesRemoteDataSource,
                                              cacheDataSource: ratesCacheDataSource)
        let ratesUseCases = RatesUseCases(repository: ratesRepository)

        let portfolioDataSource = DBCryptoPortfolioDataSource(with: container)
        let portfolioRepository = CryptoPortfolioRepository(
            localDataSource: portfolioDataSource)
        let portfolioUseCases = CryptoPortfolioUseCases(
            cryptoPortfolioRepository: portfolioRepository,
            cryptoRepository: repository, ratesRepository: ratesRepository)

        let userCacheDataSource = UDUserDataSource(userDefaultsManager: UserDefaultsManager())
        let userRepository = UserRepository(datasource: userCacheDataSource)
        let userUseCases = UserUseCases(repository: userRepository)

        let remoteHistoryDataSource = RemoteCoincapHistoryDataSource(networkManager: NetworkManager())
        let localHistoryDataSource = DBCryptoHistoryDataSource(with: container)
        let historyRepository = CryptoHistoryRepository(localDataSource: localHistoryDataSource, remoteDataSource: remoteHistoryDataSource)
        let historyUseCases = CryptoHistoryUseCase(repository: historyRepository)

        let viewModel = HomeViewModel(cryptoUseCases: cryptoUseCases,
                                      cryptoPortfolioUseCases: portfolioUseCases,
                                      ratesUseCases: ratesUseCases,
                                      userUseCases: userUseCases,
                                      historyUseCases: historyUseCases)
        let view = HomeView(VM: viewModel)
        return view
    }
}
