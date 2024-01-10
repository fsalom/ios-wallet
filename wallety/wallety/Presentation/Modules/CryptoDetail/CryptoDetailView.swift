//
//  CryptoDetailView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 6/12/23.
//

import SwiftUI
import Charts

struct CryptoDetailView: View {
    @ObservedObject var VM: CryptoDetailViewModel

    var body: some View {
        ScrollView {
            VStack{
                ChartView()
                VStack {
                    Text("Precio por moneda: \(VM.crypto.price)")
                        .font(.footnote)
                        .foregroundStyle(Color.gray)
                    Text("\(VM.total)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("\(VM.quantity) \(VM.crypto.symbol)")
                        .font(.caption)
                }
                .clipShape(Rectangle())
                HStack(alignment: .bottom) {
                    TextField(text: $VM.quantityText) {
                        Text("Cantidad")
                    }
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .keyboardType(.decimalPad)
                    Spacer()
                    Button {
                        VM.addToMyPortfolio()
                    } label: {
                        Image(systemName: "arrowtriangle.right.fill")
                    }.padding(20).background(Color.active)
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                }
                .padding(EdgeInsets(top: 20, leading: 20, bottom: 10, trailing: 20))
                HStack(alignment: .bottom) {
                    Text("$")
                    TextField(text: $VM.priceText) {
                        Text("Precio")
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                .font(.system(size: 30))
                .fontWeight(.bold)
                .keyboardType(.decimalPad)

                LazyVStack(alignment: .leading, content: {
                    ForEach(VM.cryptosPortfolio) { portfolio in
                        HStack(spacing: 10) {
                            Text("\(portfolio.quantityFormatted) \(portfolio.crypto.symbol)")
                            Spacer()
                            Text("\(portfolio.crypto.price)")
                                .fontWeight(.bold)
                            Button {
                                VM.delete(this: portfolio)
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .padding(5)
                                    .foregroundStyle(Color.white)
                                    .frame(width: 20, height: 20)
                                    .background(Color.red)
                                    .clipShape(Circle())
                            }

                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                    }
                })
                Spacer()
            }.padding(.top, 40)
        }.background(Color.background)
            .foregroundColor(.primary)
            .navigationTitle("\(VM.crypto.name)")
            .accentColor(.black)
            .task {
                await VM.load()
            }
    }

    @ViewBuilder
    private func ChartView() -> some View {
        ZStack {
            Chart(VM.cryptoHistoryPrices, id: \.time) {
                LineMark(
                    x: .value("Date", $0.dayAndHour),
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
                                    //VM.updateTotal(with: date)
                                }
                                .onEnded({ _ in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        VM.setOriginalPrice()
                                    }
                                })
                        )
                }
            }
        }
    }
}

#Preview {
    CryptoDetailView(VM: CryptoDetailViewModel(
        crypto: Crypto(symbol: "BTC",
                       name: "bitcoin",
                       priceUsd: 40000.00,
                       marketCapUsd: 0.0,
                       changePercent24Hr: 2.0),
        portfolioUseCases: CryptoPortfolioMockUseCases(),
        rateUseCases: RatesMockUseCases(), 
        cryptoHistoryUseCases: CryptoHistoryMockUseCases()
    ))
}
