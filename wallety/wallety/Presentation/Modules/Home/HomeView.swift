//
//  HomeView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {

        GeometryReader{
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.all, edges: .top)
        }.background(Color.background)
/*
        HomeProfileView().padding(.horizontal, 20)
        CurrentAmountView().padding(.horizontal, 20)
        HorizontalListFavoriteAssetsView()
        Text("Assets").padding(.horizontal, 20)
        ListAssetsView().padding(.horizontal, 20)
*/
    }
}

struct Home: View {
    let size: CGSize
    let safeArea: EdgeInsets
    @State private var offsetY: CGFloat = 0

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HeaderView()
                HorizontalListFavoriteAssetsView()
                ListAssetsView().padding(.horizontal, 20)
            }
        }.scrollIndicators(.hidden)
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
                    GeometryReader(content: { geometry in
                        let rect = geometry.frame(in: .global)
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
                    })
                    Text("42.123,34€")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .scaleEffect(1 - (progress * 0.40))
                        .offset(y: progress)
                        .padding(.bottom, 15)
                    Divider()
                        .padding(0)
                        .opacity(progress < 1 ? 0 : 1)
                })
                .padding(.top, safeArea.top)
            }
            .frame(maxHeight: .infinity)
            .frame(height: headerHeight(with: size.height, and: progress),
                   alignment: .top)
            .offset(y: -minY)
        }
        .frame(height: headerHeight())
        .zIndex(1000)


    }

    func headerHeight(with height: CGFloat? = 0,
                      and progress: CGFloat? = 1) -> CGFloat {
        guard let height, let progress else { return 250 - minimumHeaderHeight }
        var currentHeight = 250 - (height * progress)
        currentHeight = currentHeight < minimumHeaderHeight ? minimumHeaderHeight : currentHeight
        print(currentHeight)
        return currentHeight
    }

    var minimumHeaderHeight: CGFloat {
        65 + safeArea.top
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
                    .shadow(radius: 1)
                }
            }).padding(2)
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
