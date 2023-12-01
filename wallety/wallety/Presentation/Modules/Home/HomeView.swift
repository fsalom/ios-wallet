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
        }.background(Color(.background))
    }
}

struct HomeProfileView: View {
    var body: some View {
        HStack {
            Image(.profile)
                .resizable()
                .frame(width: 60, height: 60)
                .background(Color.gray)
                .clipShape(Circle())



            VStack(alignment: .leading, spacing: 5, content: {
                Text("Hola 👋")
                Text("Fernando Salom")
                    .fontWeight(.bold)
            }).padding(5)
            Spacer()
        }
    }
}

struct CurrentAmountView: View {
    var body: some View {
        VStack() {
            HStack(){
                Text("39.284,02€")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                Image(systemName: "arrow.up.forward")
                    .colorInvert()
                    .padding(5)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                Spacer()
            }
        }.frame(height: 150)
    }
}

struct HorizontalListFavoriteAssetsView: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10, content: {
                ForEach(1...10, id: \.self) { count in
                    VStack(alignment: .trailing, content: {
                        HStack{
                            Image(systemName: "star")
                            Spacer()
                        }
                        Spacer()
                        Image(.bitcoin)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                        Text("Bitcoin").fontWeight(.bold)
                        Text("35.134€")
                    })
                    .padding(20)
                    .frame(width: 150, height: 200)
                    .background(Color.white)
                    .clipShape(
                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
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
                    Image(.bitcoin)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .clipShape(Circle())


                    VStack(alignment: .leading, content: {
                        Text("Bitcoin")
                            .fontWeight(.bold)
                        Text("BTC")
                    })
                    Spacer()
                    VStack(alignment: .trailing, content: {
                        Text("36.541,00€")
                            .fontWeight(.bold)
                        Text("+12,23%")
                    })
                }
                .padding(10)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))

            }
        })
    }
}

#Preview {
    HomeView()
}
