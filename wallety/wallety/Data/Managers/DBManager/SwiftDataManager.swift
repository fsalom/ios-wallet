//
//  DBManager.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation
import SwiftData

class SwiftDataManager {
    var container: ModelContainer = {
        let schema = Schema([
            CryptoDBO.self,
            CryptoPortfolioDBO.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    func getT<T>(item: T) -> T where T : PersistentModel  {
        item
    }

    func fetchAll<T>(_ item: T.Type) async throws -> [T] where T : PersistentModel{
        try await container.mainContext.fetch(FetchDescriptor<T>())
    }

    func fetch<T>(item: T) async throws -> T? where T : PersistentModel {
        try await container.mainContext.fetch(FetchDescriptor<T>(), batchSize: 1).first
    }

    func insert<T>(item: T) async where T : PersistentModel {
        await container.mainContext.insert(item)
    }

    func save() async throws {
        try await container.mainContext.save()
    }
}
