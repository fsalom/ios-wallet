//
//  DBCryptoHistoryDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation
import SwiftData

class DBCryptoHistoryDataSource: LocalCryptoHistoryDataSourceProtocol {
    private var context: ModelContext

    init(with container: ModelContainer) {
        context = ModelContext(container)
    }

    func getHistory(for crypto: String) async throws -> [CryptoHistoryDBO] {
        []
    }

    func save(this history: CryptoHistoryDBO) {        
    }
}
