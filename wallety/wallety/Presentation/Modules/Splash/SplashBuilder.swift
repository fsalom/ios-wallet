//
//  SplashBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 28/12/23.
//

import Foundation

class SplashBuilder {
    func build() -> SplashView {
        let userCacheDataSource = UDUserDataSource(userDefaultsManager: UserDefaultsManager())
        let userRepository = UserRepository(datasource: userCacheDataSource)
        let userUseCases = UserUseCases(repository: userRepository)

        let viewModel = SplashViewModel(userUseCases: userUseCases)

        let view = SplashView(VM: viewModel)
        return view
    }
}
