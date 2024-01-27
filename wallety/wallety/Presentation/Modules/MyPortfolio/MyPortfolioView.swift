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
        }.background(Color.background)
            .searchable(text: $VM.searchText)
    }

    @ViewBuilder
    func CryptoRow(with portfolio: CryptoPortfolio) -> some View {
        HStack {
            KFAnimatedImage(portfolio.crypto.imageUrl)
                .frame(width: 40, height: 40)
                .background(Color.white)
                .clipShape(Circle())

            VStack(alignment: .leading, content: {
                Text(portfolio.crypto.name)
                    .fontWeight(.bold)
                Text(portfolio.crypto.symbol)
            })
            Spacer()
            VStack(alignment: .trailing, content: {
                Text(portfolio.valuePerQuantity)
                    .fontWeight(.bold)
                Text(portfolio.quantityFormatted + " \(portfolio.crypto.symbol)")
            })
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    MyPortfolioView(VM: MyPortfolioViewModel(portfolioUseCases: CryptoPortfolioMockUseCases(),
                                             ratesUseCases: RatesMockUseCases()))
}
