//
//  ProfileViewmodel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import Foundation
import UIKit
import SwiftUI

struct ProfileData {
    var currencies: [Rate]
    var currentCurrency: Rate
    var user: User?
}

class ProfileViewModel: ObservableObject {

    var rateUseCases: RatesUseCasesProtocol
    var userUseCases: UserUseCasesProtocol
    @Published var currentCurrency: Rate = Rate.default()
    @Published var currencies: [Rate] = []
    @Published var errorMessage: String = ""
    @Published var name: String = ""
    @Published var image: Data?
    @Published var avatarImage: Image?

    init(rateUseCases: RatesUseCasesProtocol, userUseCases: UserUseCasesProtocol) {
        self.rateUseCases = rateUseCases
        self.userUseCases = userUseCases        
    }

    func load() {
        Task {
            let data = try await loadData()
            await MainActor.run {
                self.currencies = data.currencies
                self.currentCurrency = data.currentCurrency
                self.name = data.user?.name ?? "Desconocido"
                self.image = data.user?.image
                if let data = image,
                   let uiImage = UIImage(data: data) {
                    avatarImage = Image(uiImage: uiImage)
                    return
                }
            }
        }
    }

    func loadData() async throws -> ProfileData {
        async let currencies = try await rateUseCases.getFilteredCurrenciesRates()
        async let currentCurrency = try await rateUseCases.getCurrentCurrency()
        async let user = try await userUseCases.getMe()
        return try await ProfileData(
            currencies: currencies,
            currentCurrency: currentCurrency,
            user: user)
    }

    func select(this currency: Rate) {
        currentCurrency = currency
        save(this: currency)
    }

    func save(this image: Data) {
        Task {
            do {
                try await self.userUseCases.save(this: image)
            } catch {
                self.errorMessage = "_ERROR_"
            }
        }
    }

    private func save(this currency: Rate) {
        Task {
            do {
                try await self.rateUseCases.select(this: currency)
            } catch {
                self.errorMessage = "_ERROR_"
            }
        }
    }

    func clearDB() {
        Task {
            
        }
    }
}
