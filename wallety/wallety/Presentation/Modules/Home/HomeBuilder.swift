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
            cacheManager: UserDefaultsManager())
        let cryptoUseCases = CryptoUseCases(repository: repository)

        let ratesLocalDataSource = DBRatesDataSource(with: container)
        let ratesRemoteDataSource = CoincapRatesDataSource(networkManager: NetworkManager())
        let ratesCacheDataSource = UDRatesDataSource(with: UserDefaultsManager())
        let ratesRepository = RatesRepository(localDataSource: ratesLocalDataSource,
                                              remoteDataSource: ratesRemoteDataSource,
                                              cacheDataSource: ratesCacheDataSource)
        let ratesUseCases = RatesUseCases(repository: ratesRepository)


        let viewModel = HomeViewModel(cryptoUseCases: cryptoUseCases, ratesUseCases: ratesUseCases)
        let view = HomeView(VM: viewModel)
        return view
    }
}
