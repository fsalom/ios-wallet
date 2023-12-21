//
//  ProfileBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 20/12/23.
//

import Foundation
import SwiftData

class ProfileBuilder {
    func build(with container: ModelContainer) -> ProfileView {

        let ratesLocalDataSource = DBRatesDataSource(with: container)
        let ratesRemoteDataSource = CoincapRatesDataSource(networkManager: NetworkManager())
        let ratesCacheDataSource = UDRatesDataSource(with: UserDefaultsManager())
        let ratesRepository = RatesRepository(localDataSource: ratesLocalDataSource,
                                              remoteDataSource: ratesRemoteDataSource,
                                              cacheDataSource: ratesCacheDataSource)
        let ratesUseCases = RatesUseCases(repository: ratesRepository)

        let viewModel = ProfileViewModel(useCase: ratesUseCases)

        let view = ProfileView(VM: viewModel)
        return view
    }
}
