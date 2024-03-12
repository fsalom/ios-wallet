//
//  MyPortfolioViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation

fileprivate enum MyPortfolioError: Error {
    case failedToGetUpdatedPrice

    var localizedDescription: String {
        switch self {
        case .failedToGetUpdatedPrice:
            return "No se pudieron actualizar los precios"
        }
    }
}

@MainActor
class MyPortfolioViewModel: ObservableObject {
    @Published var cryptos: [CryptoPortfolio] = []
    @Published var total: String = ""
    @Published var bannerUI: BannerUI = BannerUI(show: false, data: BannerModifier.BannerData())
    @Published var searchText: String = "" {
        didSet{
            filter(with: searchText)
        }
    }

    fileprivate struct PortfolioData {
        var cryptosPorfolio: [CryptoPortfolio]
    }
    private var originalCryptos: [CryptoPortfolio] = []
    private var portfolioUseCases: CryptoPortfolioUseCasesProtocol
    private var ratesUseCases: RatesUseCasesProtocol
    private var cryptoUseCases: CryptoUseCasesProtocol
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

    init(portfolioUseCases: CryptoPortfolioUseCasesProtocol,
         ratesUseCases: RatesUseCasesProtocol,
         cryptoUseCases: CryptoUseCasesProtocol) {
        self.portfolioUseCases = portfolioUseCases
        self.ratesUseCases = ratesUseCases
        self.cryptoUseCases = cryptoUseCases
    }

    func load() {
        Task {
            do {
                let data = try await loadData()
                let totalUsd = try await self.portfolioUseCases.getTotalPriceUsd()
                let total = try await self.portfolioUseCases.getTotalFormattedWithCurrentCurrency(of: totalUsd)

                self.cryptos = try await updateCryptosPrice(for: data.cryptosPorfolio)
                self.total = total
                self.originalCryptos = data.cryptosPorfolio
            } catch {
                self.error = .generic(error.localizedDescription)
            }
        }
    }

    private func updateCryptosPrice(for assets: [CryptoPortfolio]) async throws -> [CryptoPortfolio] {
        do {
            for asset in assets {
                guard let crypto = try await cryptoUseCases.getCrypto(with: asset.crypto.symbol) else {
                    continue
                }
                asset.crypto = crypto
            }
            return assets
        } catch {
            throw MyPortfolioError.failedToGetUpdatedPrice
        }
    }

    private func loadData() async throws -> PortfolioData  {
        async let cryptos = try await self.portfolioUseCases.getCryptosPortfolio()
        async let currentCurrency = try await self.ratesUseCases.getCurrentCurrency()
        return try await PortfolioData(
            cryptosPorfolio: self.portfolioUseCases.update(these: cryptos,
                                                           with: currentCurrency)
        )
    }

    func filter(with text: String) {
        if text.isEmpty {
            self.cryptos = originalCryptos
        }else{
            self.cryptos = portfolioUseCases.filter(these: originalCryptos, with: text)
        }
    }
}
