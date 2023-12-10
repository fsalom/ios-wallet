//
//  HomeViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var total: String = "---"
    @Published var error: String = ""

    var useCase: CryptoUseCasesProtocol

    init(useCase: CryptoUseCasesProtocol) {
        self.useCase = useCase
    }

    func load() {
        Task {
            do {
                let (isUpdated, cryptos) = try await self.useCase.getIsUpdatedAndCryptos()
                let total = try await self.useCase.getTotal()
                if isUpdated { return }
                await MainActor.run {
                    self.cryptos = cryptos
                    self.total = total
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }
}
