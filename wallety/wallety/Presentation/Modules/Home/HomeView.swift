//
//  HomeView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI
import Charts

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
                        if !VM.favoriteCryptos.isEmpty {
                            HorizontalListFavoriteAssetsView(favoriteCryptos: VM.favoriteCryptos)
                        }
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
                    ChartView(progress: progress)
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
            VM.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 5, content: {
                Text("Hola 👋")
                Text(VM.name)
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

    struct Data {
        var day: String
        var sales: Float
    }
    @ViewBuilder
    private func ChartView(progress: CGFloat) -> some View {
        let data = [Data(day: "1", sales: 30),
                    Data(day: "2", sales: 30),
                    Data(day: "3", sales: 50),
                    Data(day: "4", sales: 60),
                    Data(day: "5", sales: 70),
                    Data(day: "6", sales: 80),
                    Data(day: "7", sales: 30),
                    Data(day: "8", sales: 30),
                    Data(day: "9", sales: 30),
                    Data(day: "10", sales: 40),
                    Data(day: "11", sales: 40),
                    Data(day: "12", sales: 40),
                    Data(day: "13", sales: 60),
                    Data(day: "14", sales: 90),
                    Data(day: "15", sales: 90),
                    Data(day: "16", sales: 90),
                    Data(day: "17", sales: 90)]

        Chart(data, id: \.day) {
            LineMark(
                x: .value("Date", $0.day),
                y: .value("Sales", $0.sales)
            )
            .lineStyle(StrokeStyle(lineWidth: 1))
            .foregroundStyle(.black)
            .interpolationMethod(.cardinal)
            .symbol(Circle().strokeBorder(lineWidth: 1))
            .symbolSize(0)
        }
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .opacity(1.0 - (progress * 2.5))
    }
}



struct HorizontalListFavoriteAssetsView: View {
    @Environment(\.modelContext) private var context

    var favoriteCryptos: [Crypto]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10, content: {
                ForEach(favoriteCryptos) { crypto in
                    NavigationLink {
                        CryptoDetailBuilder().build(with: crypto, and: context.container)
                    } label: {
                        FavoriteCryptoRow(with: crypto)
                    }
                }
            }).padding(2)
        }.contentMargins(.horizontal, 20, for: .scrollContent)
    }

    @ViewBuilder
    func FavoriteCryptoRow(with crypto: Crypto) -> some View {
        VStack(alignment: .trailing, content: {
            HStack{
                Image(systemName: "star.fill").foregroundColor(.yellow)
                Spacer()
            }
            Spacer()
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
            Text(crypto.name).fontWeight(.bold)
            Text(crypto.price)
        })
        .padding(20)
        .frame(width: 150, height: 200)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
        .shadow(radius: 1)
    }
}

struct ListCryptoView: View {
    @Environment(\.modelContext) private var context

    var cryptos: [Crypto]
    var body: some View {
        LazyVStack(spacing: 10, content: {
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
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
                    .frame(width: 50, height: 50)
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
                               ratesUseCases: RatesMockUseCases(),
                               userUseCases: UserMockUseCases()))
}
