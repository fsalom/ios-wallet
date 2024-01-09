//
//  TopCryptosView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import SwiftUI

struct TopCryptosView: View {
    @ObservedObject var VM: TopCryptosViewModel
    @Environment(\.modelContext) private var context

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(content: {
                ForEach(VM.cryptos) { crypto in
                    NavigationLink {
                        CryptoDetailBuilder().build(with: crypto, and: context.container)
                    } label: {
                        CryptoRow(with: crypto)
                    }
                }
            }).task {
                await VM.load()
            }
            .padding(.horizontal, 20)
        }.background(Color.background)
            .searchable(text: $VM.searchText)
    }

    @ViewBuilder
    func CryptoRow(with crypto: Crypto) -> some View {
        HStack {
            ZStack {
                AsyncImage(url: crypto.imageUrl) { image in
                    image.resizable()
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
                if crypto.isFavorite {
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.yellow)
                        .padding(5)
                        .background(.white)
                        .clipShape(Circle())
                        .offset(x: 15, y: 15)
                        .shadow(radius: 1)

                }
            }
            VStack(alignment: .leading, content: {
                Text(crypto.name)
                    .fontWeight(.bold)
                Text(crypto.symbol)
            })
            Spacer()
            VStack(alignment: .trailing, content: {
                Text("\(crypto.price)")
                    .fontWeight(.bold)
                Text("\(crypto.changePercent24HrFormatted)%")
            })
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    TopCryptosView(VM: TopCryptosViewModel(cryptoUseCases: CryptoMockUseCases(), ratesUseCases: RatesMockUseCases()))
}
