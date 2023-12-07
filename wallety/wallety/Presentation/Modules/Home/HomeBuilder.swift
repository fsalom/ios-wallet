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
        let localDataSource = CryptoDBDataSource(with: container)
        let repository = CryptoRepository(
            localDataSource: localDataSource,
            remoteDataSource: networkDataSource)
        let useCase = CryptoUseCases(repository: repository)

        let viewModel = HomeViewModel(useCase: useCase)
        let view = HomeView(VM: viewModel)
        return view
    }
}
