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
                                    .frame(width: 200, height: 200)
                                    .foregroundColor(.green)
                                if let avatarImage {
                                    avatarImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "camera")
                                        .foregroundColor(.white)
                                        .imageScale(.small)
                                        .frame(width: 80, height: 80)
                                }
                            }.padding()

                        }
                        .onChange(of: avatarItem, { oldValue, newValue in
                            Task {
                                if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                                    VM.image = data
                                    VM.save(this: data)
                                    if let uiImage = UIImage(data: data) {
                                        avatarImage = Image(uiImage: uiImage)
                                        return
                                    }
                                }
                            }
                        })

                        List{
                            Button(action: {

                            }, label: {
                                Text("Borrar imagen")
                            })
                        }
                    }
                    .background(Color.backgroundList)
                } label: {
                    HStack {
                        avatarImage?
                            .resizable()
                            .clipShape(Circle())
                            .frame(
                                width: 30,
                                height: 30)
                        Text("Cambiar imagen")
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
        }
        .task {
            VM.load()
            if let data = VM.image,
               let uiImage = UIImage(data: data) {
                avatarImage = Image(uiImage: uiImage)
                return
            }
        }
    }
}

#Preview {
    ProfileView(VM: ProfileViewModel(rateUseCases: RatesMockUseCases(), userUseCases: UserMockUseCases()))
}
