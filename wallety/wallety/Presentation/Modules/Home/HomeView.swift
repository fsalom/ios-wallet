//
//  HomeView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var VM: HomeViewModel
    @State private var showingPopover = false

    let safeArea: EdgeInsets = EdgeInsets()

    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                ScrollView(.vertical) {
                    VStack {
                        HeaderView()
                        HorizontalListFavoriteAssetsView()
                        ListCryptoView(cryptos: VM.cryptos).padding(.horizontal, 20)
                    }
                }.scrollIndicators(.hidden)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
            .background(Color.background)
            .onAppear() {
                VM.load()
            }
        }
    }

    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader {
            let size = $0.size
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let maxHeight = headerHeight()
            let progress = max(min((-minY / maxHeight), 1), 0)

            ZStack {
                Rectangle().fill(Color.background)
                VStack(spacing: 0, content: {
                    GeometryReader(content: { _ in
                        HomeProfileView(progress: progress)
                    })
                    Text(VM.total)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scaleEffect(1 - (progress * 0.40))
                        .offset(y: progress)
                        .padding(.bottom, 15)
                    Divider()
                        .padding(0)
                        .opacity(progress < 1 ? 0 : 1)
                })
            }
            .frame(maxHeight: .infinity)
            .frame(height: headerHeight(with: size.height, and: progress),
                   alignment: .top)
            .offset(y: -minY)
        }
        .frame(height: headerHeight())
        .zIndex(1000)
    }

    @ViewBuilder
    func HomeProfileView(progress: CGFloat) -> some View {
        HStack {
            Image(.profile)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Hola 👋")
                Text("Fernando Salom")
                    .fontWeight(.bold)
            }).padding(5)
                .opacity(1.0 - (progress * 2.5))
            Spacer()
        }.padding(.horizontal, 20)
    }

    func headerHeight(with height: CGFloat? = 0,
                      and progress: CGFloat? = 1) -> CGFloat {
        guard let height, let progress else { return 250 - minimumHeaderHeight }
        var currentHeight = 250 - (height * progress)
        currentHeight = currentHeight < minimumHeaderHeight ? minimumHeaderHeight : currentHeight
        return currentHeight
    }

    var minimumHeaderHeight: CGFloat {
        65 + safeArea.top
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
                    .shadow(radius: 1)
                }
            }).padding(2)
        }.contentMargins(.horizontal, 20, for: .scrollContent)
    }
}

struct ListCryptoView: View {
    @Environment(\.modelContext) private var context

    var cryptos: [Crypto]
    var body: some View {
        LazyVStack(spacing: 20, content: {
            ForEach(cryptos) { crypto in
                NavigationLink {
                    CryptoDetailBuilder().build(with: crypto, and: context.container)
                } label: {
                    CryptoRow(with: crypto)
                }
            }
        })
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
                Text("\(crypto.price)")
                    .fontWeight(.bold)
                Text("\(crypto.changePercent24HrFormatted)%")
            })
        }
        .padding(10)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .foregroundColor(.primary)
    }
}

#Preview {
    HomeView(VM: HomeViewModel(cryptoUseCases: CryptoMockUseCases(),
                               cryptoPortfolioUseCases: CryptoPortfolioMockUseCases(),
                               ratesUseCases: RatesMockUseCases()))
}
