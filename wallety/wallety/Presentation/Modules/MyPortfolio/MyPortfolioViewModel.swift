//
//  MyPortfolioViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation

class MyPortfolioViewModel: ObservableObject {
    @Published var cryptos: [CryptoPortfolio] = []
    @Published var error: String = ""

    var useCase: CryptoPortfolioUseCasesProtocol

    init(useCase: CryptoPortfolioUseCasesProtocol) {
        self.useCase = useCase
    }

    func load() {
        Task {
            do {
                let cryptos = try await self.useCase.getCryptosPortfolio()
                await MainActor.run {
                    self.cryptos = cryptos
                }
            } catch {
                self.error = "_ERROR_"
            }
        }
    }
}
