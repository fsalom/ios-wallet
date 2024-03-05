//
//  HomeViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var cryptos = [Crypto]()
    @Published var favoriteCryptos = [Crypto]()
    @Published var totalsPerDay: [CryptoHistory] = [] {
        didSet {
            let sortedtotalsPerDay = totalsPerDay.sorted(by: {$0.priceUsd < $1.priceUsd})
            maxValueForChart = sortedtotalsPerDay.last?.priceUsd ?? 0.0
            minValueForChart = sortedtotalsPerDay.first?.priceUsd ?? 0.0
        }
    }
    @Published var minValueForChart: Float = 0.0
    @Published var maxValueForChart: Float = 0.0
    @Published var user: User?
    @Published var total: String = "---"
    @Published var error: String = ""
    @Published var isLoading: Bool = false
    
    struct HomeData {
        var cryptos: [Crypto]
        var portfolios: [CryptoPortfolio]
        var currentCurrency: Rate
        var user: User?
    }
    
    private var originalTotal: String = ""
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
    }
    
    @MainActor
    func update() {
        Task {
            isLoading = true
            await load()
            isLoading = false
        }
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
            
            DispatchQueue.main.async {
                self.cryptos = self.cryptoUseCases.update(these: cryptosWithoutFavorite,
                                                     with: data.currentCurrency)
                self.favoriteCryptos = self.cryptoUseCases.update(these: favoriteCryptos,
                                                             with: data.currentCurrency)
                self.total = totalFormatted
                self.totalsPerDay = Array(totalsPerDay)
                self.totalsPerDay.append(todayHistory)
                self.currentCurrency = data.currentCurrency
                self.user = data.user
            }
        } catch {
            self.error = "_ERROR_"
        }
    }
    
    func loadData() async throws -> HomeData {
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
            await MainActor.run {
                self.total = total
            }
        }
    }
    
    func setOriginalTotal(){
        total = originalTotal.isEmpty ? total : originalTotal
    }
}
