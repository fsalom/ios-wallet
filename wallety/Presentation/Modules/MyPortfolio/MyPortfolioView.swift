//
//  MyPortfolioView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import SwiftUI
import Kingfisher

struct MyPortfolioView: View {
    @ObservedObject var VM: MyPortfolioViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView(.vertical) {
            Text(VM.total)
                .font(.largeTitle)
                .fontWeight(.bold)
            LazyVStack(content: {
                ForEach(VM.cryptos) { crypto in
                    NavigationLink {
                        CryptoDetailBuilder().build(with: crypto.crypto, and: context.container)
                    } label: {
                        CryptoRow(with: crypto)
                    }
                }
            }).onAppear {
                VM.load()
            }
            .padding(.horizontal, 20)
        }
        .background(Color.background)
        .banner(data: $VM.bannerUI.data, show: $VM.bannerUI.show)
        .searchable(text: $VM.searchText, prompt: "Búsqueda")
    }

    @ViewBuilder
    func CryptoRow(with portfolio: CryptoPortfolio) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                KFAnimatedImage(portfolio.crypto.imageUrl)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())

                VStack(alignment: .leading, content: {
                    Text(portfolio.crypto.name)
                        .fontWeight(.bold)
                    Text(portfolio.crypto.symbol)
                        .font(.footnote)
                })
                Spacer()
                VStack(alignment: .trailing, content: {
                    Text(portfolio.valuePerQuantity)
                        .fontWeight(.bold)
                    Text(portfolio.quantityFormatted + " \(portfolio.crypto.symbol)")
                        .font(.footnote)
                })
            }
            .padding(10)
            Divider()
        }
    }
}

#Preview {
    MyPortfolioView(VM: MyPortfolioViewModel(portfolioUseCases: CryptoPortfolioMockUseCases(),
                                             ratesUseCases: RatesMockUseCases(),
                                             cryptoUseCases: CryptoMockUseCases()))
}
