//
//  TopCryptosView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import SwiftUI
import Kingfisher

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
            .searchable(text: $VM.searchText, prompt: "Búsqueda")
            .banner(data: $VM.bannerUI.data, show: $VM.bannerUI.show)
    }

    @ViewBuilder
    func CryptoRow(with crypto: Crypto) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    KFAnimatedImage(crypto.imageUrl)
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(Circle())
                    if crypto.isFavorite {
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.yellow)
                            .padding(5)
                            .background(.white)
                            .clipShape(Circle())
                            .offset(x: 12, y: 12)
                            .shadow(radius: 1)

                    }
                }
                VStack(alignment: .leading, content: {
                    Text(crypto.name)
                        .fontWeight(.bold)
                    Text(crypto.symbol)
                        .font(.footnote)
                })
                Spacer()
                VStack(alignment: .trailing, spacing: 0, content: {
                    Text("\(crypto.price)")
                        .fontWeight(.bold)
                    Text("\(crypto.changePercent24HrFormatted)%")
                        .foregroundStyle(crypto.changePercent24Hr > 0 
                                         ? .green : .red)
                        .fontWeight(.bold)
                        .font(.footnote)
                        .padding(4)
                        .background(crypto.changePercent24Hr > 0 ?
                                    Color.flagGreenBackground :
                                    Color.flagRedBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                })
            }
            .padding(10)
            Divider()
        }
    }
}

#Preview {
    TopCryptosView(VM: TopCryptosViewModel(cryptoUseCases: CryptoMockUseCases(), ratesUseCases: RatesMockUseCases()))
}
