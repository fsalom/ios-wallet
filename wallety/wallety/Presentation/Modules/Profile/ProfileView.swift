//
//  ProfileView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    @ObservedObject var VM: ProfileViewModel

    var body: some View {
        List {
            Section("Configuración de usuario") {
                NavigationLink {
                    VStack {
                        PhotosPicker(selection: $avatarItem, photoLibrary: .shared()) {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.green)
                                if let avatarImage {
                                    avatarImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "camera")
                                        .foregroundColor(.white)
                                        .imageScale(.small)
                                        .frame(width: 44, height: 40)
                                }
                            }.padding()

                        }
                        .onChange(of: avatarItem, { oldValue, newValue in
                            Task {
                                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                                    VM.image = data
                                    if let uiImage = UIImage(data: data) {
                                        avatarImage = Image(uiImage: uiImage)
                                        return
                                    }
                                }

                                print("Failed")
                            }
                        })
                        
                        Image(.profile)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 200, height: 200)
                        List{
                            Button(action: {

                            }, label: {
                                Text("Seleccionar")
                            })
                        }
                    }
                    .background(Color.backgroundList)
                } label: {
                    HStack {
                        Image(.profile)
                            .resizable()
                            .clipShape(Circle())
                            .frame(
                                width: 30,
                                height: 30)
                        Text("Cambiar imagen").foregroundStyle(.gray)
                        Spacer()
                    }
                }
                NavigationLink {
                    List{
                        TextField(text: $VM.name) {
                            Text("Tú Nombre")
                        }.onAppear {
                            UITextField.appearance().clearButtonMode = .whileEditing
                        }
                    }
                } label: {
                    HStack {
                        Text("Nombre")
                        Spacer()
                        Text(VM.name).foregroundStyle(.gray)
                    }
                }
            }
            Section("Configuración app") {
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
    ProfileView(VM: ProfileViewModel(rateUseCases: RatesMockUseCases(), userUseCases: UserMockUseCases()))
}
