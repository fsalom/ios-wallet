//
//  walletyApp.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 30/11/23.
//

import SwiftUI
import SwiftData

@main
struct walletyApp: App {
    var container: ModelContainer! = {
            do {
                let container = try ModelContainer(for: CryptoDBO.self, CryptoPortfolioDBO.self)
                if let url = container.configurations.first?.url.path(percentEncoded: false) {
                    print("🗄️ sqlite3 \"\(url)\"")
                } else {
                    print("🗄️ No SQLite database found.")
                }
                return container
            } catch {
                fatalError("ERROR")
            }
        }()

    var body: some Scene {
        WindowGroup {
            //DefaultTabbarView()
            MainTabbedView()
        }
        .modelContainer(container)

    }
}
