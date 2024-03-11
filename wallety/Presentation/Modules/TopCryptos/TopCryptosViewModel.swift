//
//  TopCryptosViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

class TopCryptosViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var bannerUI: BannerUI = BannerUI(show: false, data: BannerModifier.BannerData())
    @Published var searchText: String = "" {
        didSet {
            filter(with: searchText)
        }
    }

    fileprivate struct TopCryptoData {
        var cryptos: [Crypto]
    }

    private var originalCryptos: [Crypto] = []
    private var cryptoUseCases: CryptoUseCasesProtocol
    private var ratesUseCases: RatesUseCasesProtocol
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

    init(cryptoUseCases: CryptoUseCasesProtocol, ratesUseCases: RatesUseCasesProtocol) {
        self.cryptoUseCases = cryptoUseCases
        self.ratesUseCases = ratesUseCases
    }

    func load() async {
        do {
            let data = try await loadData()
            await MainActor.run {
                self.cryptos = data.cryptos
                self.originalCryptos = data.cryptos
            }
        } catch {
            self.error = .custom("Error", "Se ha producido un error cargando la información. Más detalle: \(error.localizedDescription)")
        }
    }

    private func loadData() async throws -> TopCryptoData  {
        async let cryptos = try await self.cryptoUseCases.getCryptos()
        async let currentCurrency = try await self.ratesUseCases.getCurrentCurrency()
        return try await TopCryptoData(
            cryptos: self.cryptoUseCases.update(these: cryptos, with: currentCurrency)
        )
    }

    private func filter(with text: String) {
        if text.isEmpty {
            self.cryptos = originalCryptos
        }else{
            self.cryptos = cryptoUseCases.filter(these: originalCryptos, with: text)
        }
    }
}
