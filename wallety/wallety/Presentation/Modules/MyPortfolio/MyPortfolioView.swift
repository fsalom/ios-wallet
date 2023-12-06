//
//  MyPortfolioView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import SwiftUI

struct MyPortfolioView: View {
    @ObservedObject var VM: MyPortfolioViewModel

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(content: {
                ForEach(VM.cryptos) { crypto in
                    CryptoRow(with: crypto)
                }
            }).task {
                await VM.load()
            }
        }
    }

    @ViewBuilder
    func CryptoRow(with portfolio: CryptoPortfolio) -> some View {
        HStack {
            AsyncImage(url: portfolio.crypto.imageUrl) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "star").resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, content: {
                Text(portfolio.crypto.name)
                    .fontWeight(.bold)
                Text(portfolio.crypto.symbol)
            })
            Spacer()
            VStack(alignment: .trailing, content: {
                Text("$\(portfolio.crypto.priceUsd)")
                    .fontWeight(.bold)
                Text("\(portfolio.quantity)")
            })
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    MyPortfolioView(VM: MyPortfolioViewModel(useCase: CryptoMockUseCases()))
}
