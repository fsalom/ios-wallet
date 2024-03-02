//
//  CryptoHistoryUseCase.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

class CryptoHistoryUseCase: CryptoHistoryUseCasesProtocol {
    var repository: CryptoHistoryRepositoryProtocol

    init(repository: CryptoHistoryRepositoryProtocol) {
        self.repository = repository
    }

    func getOneMonthHistory(for crypto: String) async throws -> [CryptoHistory] {
        try await self.repository.getHistoryByDay(for: crypto)
    }

    func get24HoursHistory(for crypto: String) async throws -> [CryptoHistory] {
        try await self.repository.getHistoryByHour(for: crypto).suffix(24)
    }

    func getTotalHistory(for portfolios: [CryptoPortfolio]) async throws -> [CryptoHistory] {
        var totalsPerDay: [CryptoHistory] = []
        for portfolio in portfolios {
            let histories = try await self.repository.getHistoryByDay(for: portfolio.crypto.name)
            for history in histories {
                let total = history.priceUsd * portfolio.quantity
                if let totalPerDay = totalsPerDay.first(where: {$0.time == history.time}) {
                    totalPerDay.priceUsd += total
                } else {
                    totalsPerDay.append(CryptoHistory(time: history.time,
                                                      priceUsd: total))
                }
            }
        }

        return totalsPerDay
    }
}
