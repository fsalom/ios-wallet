//
//  ProfileView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import SwiftUI
import PhotosUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @State private var avatarItem: PhotosPickerItem?
    @ObservedObject var VM: ProfileViewModel
    @State private var isConfirming = false

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
                                if VM.avatarImage != nil {
                                    VM.avatarImage?
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
                                        VM.avatarImage = Image(uiImage: uiImage)
                                        return
                                    }
                                }
                            }
                        })

                        List{
                            Button(action: {
                                VM.deleteImage()
                            }, label: {
                                Text("Borrar imagen")
                            })
                        }
                    }
                    .background(Color.backgroundList)
                } label: {
                    HStack {
                        VM.avatarImage?
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
            Section {
                Button(action: {
                    isConfirming = true
                }, label: {
                    Text("Borrar base de datos")
                })
                .confirmationDialog("Estás seguro de que deseas borrar la base de datps?",
                                    isPresented: $isConfirming,
                                    actions: {
                    Button("Eliminar", role: .destructive) {
                        VM.clearDB()
                    }
                    Button("Cancel", role: .cancel) { }
                })
            } header: {
                Text("Ajustes")
            } footer: {
                Text("version: " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "--"))
            }
        }
        .banner(data: $VM.bannerUI.data, show: $VM.bannerUI.show)
        .task {
            await VM.load()
            setProfileImage()
        }
    }

    func setProfileImage() {
        if let data = VM.image, let uiImage = UIImage(data: data) {
            VM.avatarImage = Image(uiImage: uiImage)
            return
        }
    }
}

#Preview {
    ProfileView(VM: ProfileViewModel(rateUseCases: RatesMockUseCases(), userUseCases: UserMockUseCases()))
}
