//
//  DBRatesDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation
import SwiftData

class DBRatesDataSource: LocalRatesDataSourceProtocol {
    private var context: ModelContext

    init(with container: ModelContainer) {
        context = ModelContext(container)
    }

    func save(these rates: [RateDBO]) async throws {
        for rate in rates {
            context.insert(rate)
        }
    }
    
    func getRateUsd(with id: String) async throws -> RateDBO? {
        try context.fetch(FetchDescriptor<RateDBO>(
            predicate: #Predicate {
                $0.identifier == id
            })
        ).first
    }
    
    func getRatesUsd() async throws -> [RateDBO] {
        try context.fetch(FetchDescriptor<RateDBO>())
    }

    func save(selected rate: RateDBO) async throws {
        context.insert(rate)
    }

    func getSelectedRate() async throws -> RateDBO? {
        try context.fetch(FetchDescriptor<RateDBO>(
            predicate: #Predicate {
                $0.isSelected == true
            })
        ).first
    }
}
