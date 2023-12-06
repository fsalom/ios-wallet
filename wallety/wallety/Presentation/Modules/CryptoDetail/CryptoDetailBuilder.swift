//
//  CryptoDetailBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 6/12/23.
//

import Foundation

class CryptoDetailBuilder {
    func build(with crypto: Crypto) -> CryptoDetailView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())
        let localDataSource = CryptoDBDataSource(swiftDataManager: SwiftDataManager())
        let repository = CryptoRepository(localDataSource: localDataSource,
                                          remoteDataSource: networkDataSource)
        let useCase = CryptoUseCases(repository: repository)

        let viewModel = CryptoDetailViewModel(crypto: crypto, useCase: useCase)
        let view = CryptoDetailView(VM: viewModel)
        return view
    }
}
