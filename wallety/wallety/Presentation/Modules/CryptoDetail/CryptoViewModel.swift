//
//  CryptoViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 6/12/23.
//

import Foundation

class CryptoDetailViewModel: ObservableObject {
    @Published var crypto: Crypto
    @Published var error: String = ""

    var useCase: CryptoUseCasesProtocol

    init(crypto: Crypto, useCase: CryptoUseCasesProtocol) {
        self.crypto = crypto
        self.useCase = useCase
    }

    @MainActor
    func addToMyPortfolio(with quantity: Float) {
        Task {
            do {
                try await useCase.addToMyPorfolio(this: crypto, with: quantity)
            } catch {
                self.error = "_ERROR_"
            }
        }
    }
}
