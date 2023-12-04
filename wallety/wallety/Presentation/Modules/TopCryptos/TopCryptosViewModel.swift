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

    var useCase: CryptoUseCasesProtocol

    init(useCase: CryptoUseCasesProtocol) {
        self.useCase = useCase
    }

    @MainActor
    func load() async {
        do {
            self.cryptos = try await useCase.getTopCryptos()
        } catch {
            self.error = "_ERROR_"
        }
    }
}
