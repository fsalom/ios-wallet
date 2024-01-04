//
//  HomeViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    struct HomeData {
        var cryptos: [Crypto]
        var total: String
        var portfolios: [CryptoPortfolio]
        var currentCurrency: Rate
        var user: User?
    }

    @Published var cryptos: [Crypto] = []
    @Published var favoriteCryptos: [Crypto] = []
    @Published var totalsPerDay: [CryptoHistory] = [] {
        didSet {
            let sortedtotalsPerDay = totalsPerDay.sorted(by: {$0.priceUsd < $1.priceUsd})
            minValueForChart = sortedtotalsPerDay.first?.priceUsd ?? 0.0
            maxValueForChart = sortedtotalsPerDay.last?.priceUsd ?? 0.0
        }
    }
    @Published var minValueForChart: Float = 0.0
    @Published var maxValueForChart: Float = 0.0
    @Published var name: String = "Desconocido"
    @Published var image: Image
    @Published var total: String = "---"
    @Published var error: String = ""

    var cryptoUseCases: CryptoUseCasesProtocol
    var cryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol
    var ratesUseCases: RatesUseCasesProtocol
    var userUseCases: UserUseCasesProtocol
    var historyUseCases: CryptoHistoryUseCasesProtocol
    private var currentCurrency: Rate

    init(cryptoUseCases: CryptoUseCasesProtocol,
         cryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol,
         ratesUseCases: RatesUseCasesProtocol,
         userUseCases: UserUseCasesProtocol,
         historyUseCases: CryptoHistoryUseCasesProtocol) {
        self.cryptoUseCases = cryptoUseCases
        self.cryptoPortfolioUseCases = cryptoPortfolioUseCases
        self.ratesUseCases = ratesUseCases
        self.userUseCases = userUseCases
        self.historyUseCases = historyUseCases
        self.currentCurrency = Rate.default()
        self.image = Image(.profile)
    }

    func load() {
        Task {
            do {
                let data = try await loadData()
                let favoriteCryptos = try await cryptoUseCases.getFavoriteCryptos(from: data.cryptos)
                let totalsPerDay = try await historyUseCases.getTotalHistory(for: data.portfolios).suffix(10)
                let cryptosWithoutFavorite = try await cryptoUseCases.getCryptosWithoutFavorites(from: data.cryptos)
                await MainActor.run {
                    self.cryptos = cryptoUseCases.update(these: cryptosWithoutFavorite,
                                                         with: data.currentCurrency)
                    self.favoriteCryptos = cryptoUseCases.update(these: favoriteCryptos,
                                                                 with: data.currentCurrency)
                    self.total = data.total
                    self.totalsPerDay = Array(totalsPerDay)
                    self.currentCurrency = data.currentCurrency
                    guard let user = data.user else { return }
                    self.name = user.name
                    if let image = data.user?.image {
                        if let uiImage = UIImage(data: image) {
                            self.image = Image(uiImage: uiImage)
                            return
                        }
                    } else {
                        self.image = Image(.profile)
                    }

                }
            } catch {
                await MainActor.run {
                    self.error = "_ERROR_"
                }
            }
        }
    }

    func loadData() async throws -> HomeData {
        async let cryptos = cryptoUseCases.getCryptos()
        async let total = cryptoPortfolioUseCases.getTotal()
        async let currentCurrency = ratesUseCases.getCurrentCurrency()
        async let portfolios = cryptoPortfolioUseCases.getCryptosPortfolio()
        async let user = userUseCases.getMe()
        return try await HomeData(
            cryptos: cryptos,
            total: total,
            portfolios: portfolios,
            currentCurrency: currentCurrency,
            user: user)
    }
}
