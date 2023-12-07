//
//  MyPortfolioBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation

class MyPortfolioBuilder {
    func build() -> MyPortfolioView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())
        let localDataSource = CryptoDBDataSource(swiftDataManager: SwiftDataManager.shared)
        let repository = CryptoRepository(localDataSource: localDataSource,
                                          remoteDataSource: networkDataSource)
        let useCase = CryptoUseCases(repository: repository)

        let viewModel = MyPortfolioViewModel(useCase: useCase)
        let view = MyPortfolioView(VM: viewModel)
        return view
    }
}
