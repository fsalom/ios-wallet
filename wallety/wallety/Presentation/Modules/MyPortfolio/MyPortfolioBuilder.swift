//
//  MyPortfolioBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation
import SwiftData

class MyPortfolioBuilder {
    func build(with container: ModelContainer) -> MyPortfolioView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())
        let localDataSource = CryptoDBDataSource(with: container)
        let repository = CryptoRepository(localDataSource: localDataSource,
                                          remoteDataSource: networkDataSource)
        let useCase = CryptoUseCases(repository: repository)

        let viewModel = MyPortfolioViewModel(useCase: useCase)
        let view = MyPortfolioView(VM: viewModel)
        return view
    }
}
