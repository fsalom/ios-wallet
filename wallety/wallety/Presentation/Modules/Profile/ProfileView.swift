//
//  ProfileView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var VM: ProfileViewModel

    var body: some View {
        List {
            Section("Configuración") {
                NavigationLink {
                    List(VM.currencies) { currency in
                        Button(action: {
                            VM.select(this: currency)
                        }, label: {
                            HStack {
                                if currency.symbol == VM.currentCurrency.symbol { Image(systemName: "checkmark")
                                }
                                Text("\(currency.currencySymbol)")
                            }
                        })
                    }
                } label: {
                    Text("Cambiar moneda")
                }

            }
            Section("Ajustes") {
                Button(action: {
                }, label: {
                    Text("Borrar base de datos")
                })
            }
        }.onAppear {
            VM.load()
        }
    }
}

#Preview {
    ProfileView(VM: ProfileViewModel(useCase: RatesMockUseCases()))
}
