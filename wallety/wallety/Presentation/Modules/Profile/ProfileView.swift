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
