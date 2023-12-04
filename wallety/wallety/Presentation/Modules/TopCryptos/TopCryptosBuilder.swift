//
//  TopCryptosBuilder.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

class TopCryptosBuilder {
    func build() -> TopCryptosView {
        let networkDataSource = RemoteCryptoCoinCapDataSource(networkManager: NetworkManager())

        let repository = CryptoRepository(remoteDataSource: networkDataSource)
        let useCase = CryptoUseCases(repository: repository)

        let viewModel = TopCryptosViewModel(useCase: useCase)
        let view = TopCryptosView(VM: viewModel)
        return view
    }
}
