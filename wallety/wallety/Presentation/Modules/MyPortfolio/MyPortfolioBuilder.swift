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
        let localDataSource = DBCryptoDataSource(with: container)
        let repository = CryptoRepository(localDataSource: localDataSource,
                                          remoteDataSource: networkDataSource,
                                          cacheManager: UserDefaultsManager())        
        let portfolioDataSource = DBCryptoPortfolioDataSource(with: container)
        let portfolioRepository = CryptoPortfolioRepository(
            localDataSource: portfolioDataSource)
        let portfolioUseCases = CryptoPortfolioUseCases(
            cryptoPortfolioRepository: portfolioRepository,
            cryptoRepository: repository)
        
        let viewModel = MyPortfolioViewModel(useCase: portfolioUseCases)
        let view = MyPortfolioView(VM: viewModel)
        return view
    }
}
