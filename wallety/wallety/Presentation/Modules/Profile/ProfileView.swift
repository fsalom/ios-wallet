//
//  ProfileView.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        List {
            Section("Configuración") {
                NavigationLink {
                    List {
                        Button(action: {
                        }, label: {
                            Text("€")
                        })
                        Button(action: {
                        }, label: {
                            Text("$")
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
    }
}

#Preview {
    ProfileView()
}
