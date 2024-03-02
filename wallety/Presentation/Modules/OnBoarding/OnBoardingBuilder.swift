//
//  OnBoardingBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 26/12/23.
//

import Foundation
import SwiftData
import SwiftUI

class OnBoardingBuilder {
    func build(with container: ModelContainer, screen: Binding<Screen>) -> OnBoardingView {
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

        let userCacheDataSource = UDUserDataSource(userDefaultsManager: UserDefaultsManager())
        let userRepository = UserRepository(datasource: userCacheDataSource)
        let userUseCases = UserUseCases(repository: userRepository)

        let viewModel = OnBoardingViewModel(cryptoUseCases: cryptoUseCases,
                                            ratesUseCases: ratesUseCases,
                                            userUseCases: userUseCases)

        let view = OnBoardingView(VM: viewModel, screen: screen)
        return view
    }
}
