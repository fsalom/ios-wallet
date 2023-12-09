//
//  TopCryptosBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//
import SwiftData

class TopCryptosBuilder {
    func build(with container: ModelContainer) -> TopCryptosView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())
        let localDataSource = CryptoDBDataSource(with: container)
        let repository = CryptoRepository(localDataSource: localDataSource,
                                          remoteDataSource: networkDataSource,
                                          cacheManager: UserDefaultsManager())
        let useCase = CryptoUseCases(repository: repository)

        let viewModel = TopCryptosViewModel(useCase: useCase)
        let view = TopCryptosView(VM: viewModel)
        return view
    }
}
