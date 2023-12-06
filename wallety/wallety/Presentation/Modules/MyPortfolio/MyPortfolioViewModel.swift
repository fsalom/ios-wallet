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

    var useCase: CryptoUseCasesProtocol

    init(useCase: CryptoUseCasesProtocol) {
        self.useCase = useCase
    }

    @MainActor
    func load() async {
        do {
            self.cryptos = try await useCase.getMyCryptosPortfolio()
        } catch {
            self.error = "_ERROR_"
        }
    }
}
