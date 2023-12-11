//
//  TopCryptosViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class TopCryptosViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var error: String = ""
    @Published var searchText: String = ""

    var useCase: CryptoUseCasesProtocol

    init(useCase: CryptoUseCasesProtocol) {
        self.useCase = useCase
    }

    func load() {
        Task {
            do {
                let cryptos = try await self.useCase.getCryptos()
                await MainActor.run {
                    self.cryptos = cryptos
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }
}
