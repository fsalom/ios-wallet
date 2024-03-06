//
//  ProfileBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 20/12/23.
//

import Foundation
import SwiftData

class ProfileBuilder {
    @MainActor 
    func build(with container: ModelContainer) -> ProfileView {

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

        let viewModel = ProfileViewModel(rateUseCases: ratesUseCases, userUseCases: userUseCases, container: container)

        let view = ProfileView(VM: viewModel)
        return view
    }
}
