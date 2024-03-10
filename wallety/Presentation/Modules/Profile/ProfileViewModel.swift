//
//  ProfileViewmodel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import Foundation
import UIKit
import SwiftUI
import SwiftData

struct ProfileData {
    var currencies: [Rate]
    var currentCurrency: Rate
    var user: User?
}

@MainActor
class ProfileViewModel: ObservableObject {
    
    var rateUseCases: RatesUseCasesProtocol
    var userUseCases: UserUseCasesProtocol
    var container: ModelContainer?

    @Published var currentCurrency: Rate = Rate.default()
    @Published var currencies: [Rate] = []
    @Published var error: AppError? = nil {
        didSet {
            showBanner = error != nil ? true : false
            guard let (title, description) = error?.getTitleAndDescription() else { return }
            bannerData = BannerModifier.BannerData.init(title: title, detail: description, type: .Error)
        }
    }
    @Published var image: Data?
    @Published var avatarImage: Image?
    @Published var name: String = "" {
        didSet {
            save(this: name)
        }
    }
    @Published var showBanner: Bool = false
    @Published var bannerData: BannerModifier.BannerData = BannerModifier.BannerData.init(title: "", detail: "", type: BannerModifier.BannerType.Error)

    init(rateUseCases: RatesUseCasesProtocol, userUseCases: UserUseCasesProtocol, container: ModelContainer? = nil) {
        self.rateUseCases = rateUseCases
        self.userUseCases = userUseCases        
        self.container = container
    }
    
    func load() async {
        do {
            let data = try await loadData()
            await MainActor.run {
                self.currencies = data.currencies
                self.currentCurrency = data.currentCurrency
                self.name = data.user?.name ?? "Desconocido"
                self.image = data.user?.image
            }
        } catch {
            self.error = .custom("Se ha producido un error", "La carga de información ha fallado")
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
    
    func save(this name: String) {
        Task {
            do {
                try await self.userUseCases.save(name: name)
            } catch {
                self.error = .custom("Se ha producido un error", "No se ha podido guardar el nombre")
            }
        }
    }

    func deleteImage() {
        Task {
            do {
                try await self.userUseCases.deleteImage()
                await MainActor.run {
                    self.image = nil
                    self.avatarImage = nil
                }
            } catch {
                self.error = .custom("Se ha producido un error", "No se ha podido borrar la imagen")
            }
        }
    }

    func save(this image: Data) {
        Task {
            do {
                try await self.userUseCases.save(this: image)
            } catch {
                self.error = .custom("Se ha producido un error", "No se ha podido guardar la imagen")
            }
        }
    }
    
    private func save(this currency: Rate) {
        Task {
            do {
                try await self.rateUseCases.select(this: currency)
            } catch {
                self.error = .custom("Se ha producido un error", "No se ha podido guardar la moneda")
            }
        }
    }

    func clearDB() {
        Task {
            guard let container else { return }
            do {
                let context = ModelContext(container)
                try context.delete(model: CryptoDBO.self)
                try context.delete(model: CryptoPortfolioDBO.self)
                try context.delete(model: RateDBO.self)
                try context.delete(model: FavoriteCryptoDBO.self)
            } catch {
                self.error = .custom("Se ha producido un error",
                                     "Se ha producido un error borrando la base de datos: \(error.localizedDescription)")
            }
        }
    }
}
