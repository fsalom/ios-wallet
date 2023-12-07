//
//  DBManager.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation
import SwiftData

class SwiftDataManager{
    static let shared = SwiftDataManager()
    var container: ModelContainer!
    var context: ModelContext!

    init(){
        do{
            container = try ModelContainer(for: CryptoDBO.self, CryptoPortfolioDBO.self)
            guard let container else {
                fatalError("ERROR with model container")
            }
            context = ModelContext(container)
            print(sqliteCommand)
        }
        catch{
            print(error)
        }
    }

    var sqliteCommand: String {
        if let url = container?.configurations.first?.url.path(percentEncoded: false) {
            "🗄️ sqlite3 \"\(url)\""
        } else {
            "🗄️ No SQLite database found."
        }
    }
}
