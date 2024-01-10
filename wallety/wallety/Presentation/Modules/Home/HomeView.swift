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
                        ChartView()
                        if !VM.favoriteCryptos.isEmpty {
                            HorizontalListFavoriteAssetsView(favoriteCryptos: VM.favoriteCryptos)
                        }
                        ListCryptoView(cryptos: VM.cryptos).padding(.horizontal, 20)
                    }
                }.scrollIndicators(.hidden)
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            }
            .background(Color.background)
            .task {
                await VM.load()
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
                    GeometryReader { _ in
                        HomeProfileView(progress: progress)
                    }
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
            getProfileImage()
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .background(Color.black)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 5, content: {
                Text("Hola 👋")
                Text(VM.user?.name ?? "Desconocido")
                    .fontWeight(.bold)
            }).padding(5)
                .opacity(1.0 - (progress * 2.5))
            Spacer()
        }.padding(.horizontal, 20)
    }

    func getProfileImage() -> Image {
        if let image = VM.user?.image, let data = UIImage(data: image) {
            return Image(uiImage: data)
        } else {
            return Image(.profile)
        }
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

    @ViewBuilder
    private func ChartView() -> some View {
        ZStack {
            Chart(VM.totalsPerDay, id: \.time) {
                LineMark(
                    x: .value("Date", $0.day),
                    y: .value("Price", $0.priceUsd)
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
            .chartYScale(domain: VM.minValueForChart...VM.maxValueForChart)
            .chartOverlay { (proxy: ChartProxy) in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let origin = geometry[proxy.plotAreaFrame].origin
                                    let location = CGPoint(
                                        x: value.location.x - origin.x,
                                        y: value.location.y - origin.y
                                    )
                                    guard let date = proxy.value(atX: location.x, as: String.self) else {
                                        return
                                    }
                                    VM.updateTotal(with: date)
                                }
                                .onEnded({ _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        VM.setOriginalTotal()
                                    }
                                })
                        )
                }
            }
        }
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
                               userUseCases: UserMockUseCases(),
                               historyUseCases: CryptoHistoryMockUseCases()))
}
