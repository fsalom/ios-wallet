//
//  HomeView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {

            ScrollView(.vertical, showsIndicators: false) {
                HomeProfileView().padding(.horizontal, 20)
                CurrentAmountView().padding(.horizontal, 20)
                HorizontalListFavoriteAssetsView()
                Text("Assets").padding(.horizontal, 20)
                ListAssetsView().padding(.horizontal, 20)
            }.background(
                LinearGradient(gradient: Gradient(colors: [Color(.background), .white]), startPoint: .top, endPoint: .bottom)
            )

    }
}

struct HomeProfileView: View {
    var body: some View {
        HStack {
            Image(systemName: "house").padding(10).background(Color.gray).clipShape(Circle())
            Spacer()
        }
    }
}

struct CurrentAmountView: View {
    var body: some View {
        VStack(alignment: .leading, content: {
            Text("Valor de la cartera:")
            HStack {
                Text("39.000€")
                    .font(.title)
                    .fontWeight(.bold)
                Image(systemName: "arrow.up.forward")
                Spacer()
            }
        })
    }
}

struct HorizontalListFavoriteAssetsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10, content: {
                ForEach(1...10, id: \.self) { count in
                    VStack {
                        Text("hola")
                    }
                    .frame(width: 150, height: 200)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                }
            })
        }.contentMargins(.horizontal, 20, for: .scrollContent)
    }
}

struct ListAssetsView: View {
    var body: some View {
        LazyVStack(spacing: 20, content: {
            ForEach(1...10, id: \.self) { count in
                HStack {
                    Image(systemName: "house")
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                    VStack(alignment: .leading, content: {
                        Text("Bitcoin")
                        Text("BTC")
                    })
                    Spacer()
                    VStack(alignment: .trailing, content: {
                        Text("36.541,00€")
                        Text("+12,23%")
                    })
                }
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))

            }
        })
    }
}

#Preview {
    HomeView()
}
