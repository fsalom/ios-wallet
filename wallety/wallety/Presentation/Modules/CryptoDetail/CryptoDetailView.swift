//
//  CryptoDetailView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 6/12/23.
//

import SwiftUI

struct CryptoDetailView: View {
    @ObservedObject var VM: CryptoDetailViewModel

    var body: some View {
        Button {
            VM.addToMyPortfolio(with: 10)
        } label: {
            Text("Añadir")
        }

    }
}

#Preview {
    CryptoDetailView(VM: CryptoDetailViewModel(
        crypto: Crypto(symbol: "BTC", name: "bitcoin", priceUsd: 40000.00),
        useCase: CryptoMockUseCases()
    ))
}
