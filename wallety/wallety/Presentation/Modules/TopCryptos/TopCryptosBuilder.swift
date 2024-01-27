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
        let localDataSource = DBCryptoDataSource(with: container)
        let repository = CryptoRepository(
            localDataSource: localDataSource,
            remoteDataSource: networkDataSource,
            updateInfoManager: UpdateInfoUDManager(storage: UserDefaultsManager()))
        let cryptoUseCases = CryptoUseCases(repository: repository)

        let ratesLocalDataSource = DBRatesDataSource(with: container)
        let ratesRemoteDataSource = CoincapRatesDataSource(networkManager: NetworkManager())
        let ratesCacheDataSource = UDRatesDataSource(with: UserDefaultsManager())
        let ratesRepository = RatesRepository(localDataSource: ratesLocalDataSource,
                                              remoteDataSource: ratesRemoteDataSource,
                                              cacheDataSource: ratesCacheDataSource)
        let ratesUseCases = RatesUseCases(repository: ratesRepository)


        let viewModel = TopCryptosViewModel(cryptoUseCases: cryptoUseCases, ratesUseCases: ratesUseCases)

        let view = TopCryptosView(VM: viewModel)
        return view
    }
}
