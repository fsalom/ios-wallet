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

    func getHistory(for crypto: String) async throws -> [CryptoHistory] {
        try await self.repository.getHistory(for: crypto)
    }

    func getTotalHistory(for portfolios: [CryptoPortfolio]) async throws -> [CryptoHistory] {
        var totalsPerDay: [CryptoHistory] = []
        for portfolio in portfolios {
            let histories = try await self.repository.getHistory(for: portfolio.crypto.name)
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
