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
            }).task {
                await VM.load()
            }
        }
    }

    @ViewBuilder
    func CryptoRow(with crypto: Crypto) -> some View {
        HStack {
            AsyncImage(url: URL(string: crypto.imageUrl)) { image in
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
                Text(crypto.name)
                    .fontWeight(.bold)
                Text(crypto.symbol)
            })
            Spacer()
            VStack(alignment: .trailing, content: {
                Text("$\(crypto.priceUsd)")
                    .fontWeight(.bold)
                Text("+12,23%")
            })
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}



class MockUseCase: CryptoUseCasesProtocol{
    func getTopCryptos() async throws -> [Crypto] {
        [Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
         Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00),
         Crypto(id: "", symbol: "BTC", name: "Bitcoin", priceUsd: 45200.00)
        ]
    }
}
#Preview {
    TopCryptosView(VM: TopCryptosViewModel(useCase: MockUseCase()))
}