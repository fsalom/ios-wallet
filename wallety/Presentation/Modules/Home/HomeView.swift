//
//  HomeView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI
import Charts
import Kingfisher

struct HomeView: View {
    @ObservedObject var VM: HomeViewModel
    @State private var showingPopover = false
    @State var selectedDate: String? = nil
    let safeArea: EdgeInsets = EdgeInsets()

    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                ScrollView(.vertical) {
                    VStack {
                        HeaderView(isLoading: VM.isLoading)
                        ChartView()
                        if !VM.favoriteCryptos.isEmpty {
                            HorizontalListFavoriteAssetsView(favoriteCryptos: VM.favoriteCryptos)
                        }
                        ListCryptoView(cryptos: VM.cryptos).padding(.horizontal, 20)
                    }
                }
                .scrollIndicators(.hidden)
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                .refreshable {
                    Task {
                        await VM.update()
                    }
                }
            }
            .background(Color.background)
            .banner(data: $VM.bannerUI.data, show: $VM.bannerUI.show)
        }
        .task({
            await VM.update()
        })
    }

    @ViewBuilder
    func HeaderView(isLoading: Bool) -> some View {
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
                    VStack(spacing: 0) {
                        if progress == 0 {
                            Text(selectedDate ?? "")
                                .font(.footnote)
                                .frame(height: 30)
                        }
                        if isLoading {
                            ProgressView()
                        } else {
                            Text(VM.total)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .scaleEffect(1 - (progress * 0.40))
                                .offset(y: progress)

                        }
                    }.padding(.bottom, 15)
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
        guard let height, let progress else { return 150 - minimumHeaderHeight }
        var currentHeight = 150 - (height * progress)
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
                .lineStyle(StrokeStyle(lineWidth: 2))
                .foregroundStyle(.active)
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
                                    guard let plotFrame = proxy.plotFrame else { return }
                                    let origin = geometry[plotFrame].origin
                                    let location = CGPoint(
                                        x: value.location.x - origin.x,
                                        y: value.location.y - origin.y
                                    )
                                    guard let date = proxy.value(atX: location.x, as: String.self) else {
                                        return
                                    }
                                    selectedDate = date
                                    VM.updateTotal(with: date)
                                }
                                .onEnded({ _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        VM.setOriginalTotal()
                                        selectedDate = nil
                                    }
                                })
                        )
                }
            }
            .chartBackground { proxy in
                ZStack(alignment: .topLeading) {
                    GeometryReader { geo in
                        if let selectedDate {
                            let startPositionX1 = proxy.position(forX: selectedDate) ?? 0
                            if let plotFrame = proxy.plotFrame {
                                let lineX = startPositionX1 + geo[plotFrame].origin.x
                                let lineHeight = geo[plotFrame].maxY
                                let fullWidth = geo[plotFrame].maxX
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .fill(.active)
                                        .frame(
                                            width: fullWidth - (fullWidth - lineX),
                                            height: lineHeight)
                                        .offset(x: 0, y: 0)
                                        .opacity(0.2)
                                    Rectangle()
                                        .fill(.active)
                                        .frame(width: 1, height: lineHeight)
                                }
                            }
                        }
                    }
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
        VStack(alignment: .leading, content: {
            HStack{
                KFAnimatedImage(crypto.imageUrl)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    Text(crypto.name).fontWeight(.bold)
                    Text(crypto.price).font(.footnote)
                }
                Spacer()
                Image(systemName: "star.fill").foregroundColor(.yellow)
            }
        })
        .padding(10)
        .frame(width: 200, height: 60)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))

        .shadow(radius: 1)
    }
}

struct ListCryptoView: View {
    @Environment(\.modelContext) private var context

    var cryptos: [Crypto]
    var body: some View {
        VStack(spacing: 10, content: {
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
        VStack(spacing: 0) {
            HStack {
                KFAnimatedImage(crypto.imageUrl)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())

                VStack(alignment: .leading, content: {
                    Text(crypto.name)
                        .fontWeight(.bold)
                    Text(crypto.symbol).font(.footnote)
                })
                Spacer()
                VStack(alignment: .trailing, content: {
                    Text("\(crypto.price)")
                        .fontWeight(.bold)
                    Text("\(crypto.changePercent24HrFormatted)%").font(.footnote)
                })
            }
            .padding(10)
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            .foregroundColor(.primary)
            Divider()
        }
    }
}

#Preview {
    HomeView(VM: HomeViewModel(cryptoUseCases: CryptoMockUseCases(),
                               cryptoPortfolioUseCases: CryptoPortfolioMockUseCases(),
                               ratesUseCases: RatesMockUseCases(),
                               userUseCases: UserMockUseCases(),
                               historyUseCases: CryptoHistoryMockUseCases()))
}
