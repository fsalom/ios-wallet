//
//  OnBoardingView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 26/12/23.
//

import SwiftUI
import Kingfisher

struct OnBoardingView: View {
    @ObservedObject var VM: OnBoardingViewModel
    @State var name: String = ""
    @Binding var screen: Screen
    var body: some View {
        TabView() {
            introPage()
            setName()
            selectCurrency()
            selectFavoriteCryptos()
            allPrepared()
        }
        .tabViewStyle(.page)
        .background(Color.background)
        .onAppear(perform: {
            VM.load()
        })
        .banner(data: $VM.bannerUI.data, show: $VM.bannerUI.show)
    }

    @ViewBuilder
    func introPage() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("👋 Bienvenido/a").font(.largeTitle).bold()
            Text("En esta aplicación encontrarás una forma fácil de apuntar todas tus inversiones y consultar su precio rápidamente.")
            Text("Todos los datos se almacenan de forma local por lo que solo tú conoces esta información.")
            Text("⚠️ Sí borras la aplicación se eliminará toda la información y no se podrá recuperar.")
                .font(.footnote)
                .bold()
                .padding(10)
                .foregroundColor(.white)
                .background(Color.danger)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(maxWidth: .infinity)
            Spacer()
            navBar(hasPrevious: false, hasNext: true, enableNext: true)
        }
        .padding(30)
        .padding(.top, 50)
    }

    @ViewBuilder
    func setName() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("¿Cómo quieres que te llamemos?").font(.largeTitle).bold()
            Text("Es sólo para crear una experiencia en la aplicación más cercana, podrás modificarlo en cualquier momento desde ajustes")
            TextField(text: $name) {
                Text("Escribe aquí")
            }.font(.system(size: 30))
                .fontWeight(.bold)

            Spacer()
            navBar(hasPrevious: true,
                   hasNext: true,
                   enableNext: !name.isEmpty)
        }
        .padding(30)
        .padding(.top, 50)
    }

    @ViewBuilder
    func navBar(hasPrevious: Bool, hasNext: Bool, enableNext: Bool) -> some View {
        HStack {
            if hasPrevious {
                Image(systemName: "arrow.backward.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black)
            }
            Spacer()
            if hasNext {
                Image(systemName: "arrow.forward.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(enableNext ? .black : .gray)
            }
        }
    }

    @ViewBuilder
    func selectCurrency() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Moneda").font(.largeTitle).bold()
            Text("Selecciona la moneda en la que deseas ver los precios")

            VStack {
                ForEach(VM.currencies) { currency in
                    Button {
                        VM.select(this: currency)
                    } label: {
                        HStack {
                            Image(systemName: currency.icon)
                            Text(currency.name)
                            Spacer()
                            if currency.selected {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }.padding(20)
                    }
                    .foregroundColor(currency.selected ? Color.white : Color.black)
                    .background(currency.selected ? Color.blue : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }

                Spacer()
                navBar(hasPrevious: true, hasNext: true, enableNext: true)
            }
        }
        .background(Color.background)
        .padding(20)
        .padding(.top, 50)
    }

    @ViewBuilder
    func selectFavoriteCryptos() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Favoritas").font(.largeTitle).bold()
            Text("Selecciona alguna de tus cryptos favoritas")
            TextField(text: $VM.searchText) {
                Text("Búsqueda")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(.textfield)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            ScrollView(.vertical) {
                LazyVStack(content: {
                    ForEach(VM.cryptos) { crypto in
                        CryptoRow(with: crypto)
                    }
                })
            }.searchable(text: $VM.searchText, prompt: "Búsqueda")
                .padding(20)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            navBar(hasPrevious: true, hasNext: true, enableNext: true)
        }
        .background(Color.background)
        .padding(20)
    }

    @ViewBuilder
    func CryptoRow(with crypto: Crypto) -> some View {
        Button {
            VM.favOrUnfav(this: crypto)            
        } label: {
            HStack {
                if crypto.isFavorite {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                }
                KFAnimatedImage(crypto.imageUrl)
                    .frame(width: 40, height: 40)
                    .background(Color.white)
                    .clipShape(Circle())

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
        }
    }

    @ViewBuilder
    func allPrepared() -> some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Todo listo 🚀").font(.largeTitle).bold()
            Text("Ya hemos hecho los ajustes necesarios, muchas gracias por tu tiempo.")
            Button {
                screen = .app
            } label: {
                Text("Empezar")
                    .frame(maxWidth: .infinity)
            }.buttonStyle(LargeButtonStyle(backgroundColor: Color.blue,
                                           foregroundColor: Color.white,
                                           isDisabled: false))
            Spacer()
            navBar(hasPrevious: true,
                   hasNext: false,
                   enableNext: false)
        }
        .padding(30)
        .padding(.top, 50)
        .onAppear {
            VM.save(name: name)
        }
    }
}

#Preview {
    OnBoardingView(VM: OnBoardingViewModel(cryptoUseCases: CryptoMockUseCases(), ratesUseCases: RatesMockUseCases(), userUseCases: UserMockUseCases()), screen: .constant(.onBoarding))
}
