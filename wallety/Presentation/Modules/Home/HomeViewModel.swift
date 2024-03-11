//
//  HomeViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var cryptos = [Crypto]()
    @Published var favoriteCryptos = [Crypto]()
    @Published var minValueForChart: Float = 0.0
    @Published var maxValueForChart: Float = 0.0
    @Published var user: User?
    @Published var total: String = "---"
    @Published var isLoading: Bool = false
    @Published var bannerUI: BannerUI = BannerUI(show: false, data: BannerModifier.BannerData())
    @Published var totalsPerDay: [CryptoHistory] = [] {
        didSet {
            let sortedtotalsPerDay = totalsPerDay.sorted(by: {$0.priceUsd < $1.priceUsd})
            maxValueForChart = sortedtotalsPerDay.last?.priceUsd ?? 0.0
            minValueForChart = sortedtotalsPerDay.first?.priceUsd ?? 0.0
        }
    }

    fileprivate struct HomeData {
        var cryptos: [Crypto]
        var portfolios: [CryptoPortfolio]
        var currentCurrency: Rate
        var user: User?
    }

    private var originalTotal: String = ""
    private var cryptoUseCases: CryptoUseCasesProtocol
    private var cryptoPortfolioUseCases: CryptoPortfolioUseCasesProtocol
    private var ratesUseCases: RatesUseCasesProtocol
    private var userUseCases: UserUseCasesProtocol
    private var historyUseCases: CryptoHistoryUseCasesProtocol
    private var currentCurrency: Rate
    private var error: AppError? = nil {
        didSet {
            var bannerUI = BannerUI(show: error != nil ? true : false,
                                    data: BannerModifier.BannerData.init())
            if let (title, description) = error?.getTitleAndDescription() {
                bannerUI.data = BannerModifier.BannerData.init(title: title, detail: description, type: .Error)
            }
            self.bannerUI = bannerUI
        }
    }

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
    }

    @MainActor
    func update() async {
        isLoading = true
        await load()
        isLoading = false
    }

    func load() async {
        do {
            let data = try await loadData()
            let favoriteCryptos = try await cryptoUseCases.getFavoriteCryptos(from: data.cryptos)
            let totalsPerDay = try await historyUseCases.getTotalHistory(for: data.portfolios).suffix(30)
            let cryptosWithoutFavorite = try await cryptoUseCases.getCryptosWithoutFavorites(from: data.cryptos)
            let totalUsd = try await cryptoPortfolioUseCases.getTotalPriceUsd()
            let totalFormatted = try await cryptoPortfolioUseCases.getTotalFormattedWithCurrentCurrency(of: totalUsd)
            let todayHistory = CryptoHistory(time: Int(Date().timeIntervalSince1970)*1000, priceUsd: totalUsd)

            self.cryptos = self.cryptoUseCases.update(these: cryptosWithoutFavorite,
                                                      with: data.currentCurrency)
            self.favoriteCryptos = self.cryptoUseCases.update(these: favoriteCryptos,
                                                              with: data.currentCurrency)
            self.total = totalFormatted
            self.totalsPerDay = Array(totalsPerDay)
            self.totalsPerDay.append(todayHistory)
            self.currentCurrency = data.currentCurrency
            self.user = data.user
        } catch {
            self.error = .custom("Error", "Se ha producido un error cargando la información. Más detalle: \(error.localizedDescription)")
        }
    }

    private func loadData() async throws -> HomeData {
        async let cryptos = cryptoUseCases.getCryptos()
        async let currentCurrency = ratesUseCases.getCurrentCurrency()
        async let portfolios = cryptoPortfolioUseCases.getCryptosPortfolio()
        async let user = userUseCases.getMe()
        return try await HomeData(
            cryptos: cryptos,
            portfolios: portfolios,
            currentCurrency: currentCurrency,
            user: user)
    }

    func updateTotal(with date: String) {
        Task {
            guard let totalPerDayWithThisDate = self.totalsPerDay.filter({$0.day == date}).first else {
                return
            }
            if self.originalTotal.isEmpty {
                originalTotal = total
            }
            let total = try await ratesUseCases.getFormattedWithCurrentCurrency(this: totalPerDayWithThisDate.priceUsd)
            self.total = total
        }
    }

    func setOriginalTotal(){
        total = originalTotal.isEmpty ? total : originalTotal
    }
}
