//
//  TopCryptosView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import SwiftUI

struct TopCryptosView: View {
    @ObservedObject var VM: TopCryptosViewModel

    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(content: {
                ForEach(VM.cryptos) { crypto in
                    CryptoRow(with: crypto)
                }
            }).onAppear {
                VM.load()
            }
            .padding(.horizontal, 20)
        }.background(Color.background)
            .searchable(text: $VM.searchText)
    }

    @ViewBuilder
    func CryptoRow(with crypto: Crypto) -> some View {
        HStack {
            AsyncImage(url: crypto.imageUrl) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 40, height: 40)
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
                Text("+12,23%")
            })
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    TopCryptosView(VM: TopCryptosViewModel(cryptoUseCases: CryptoMockUseCases(), ratesUseCases: RatesMockUseCases()))
}
