//
//  CoincapRatesDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

class CoincapRatesDataSource: RemoteRatesDataSourceProtocol {
    var networkManager: RemoteManagerProtocol

    init(networkManager: RemoteManagerProtocol) {
        self.networkManager = networkManager
    }

    func getRateUsd(with id: String) async throws -> RateDTO? {
        guard let url = URL(string: "https://api.coincap.io/v2/rates/\(id)") else {
            throw NetworkError.badURL
        }
        let request = URLRequest(url: url)
        let rate = try await networkManager.call(this: request,
                                                 of: RateInfoDTO.self)
        return rate.data.first
    }

    func getRatesUsd() async throws -> [RateDTO] {
        guard let url = URL(string: "https://api.coincap.io/v2/rates") else {
            throw NetworkError.badURL
        }
        let request = URLRequest(url: url)
        let rates = try await networkManager.call(this: request,
                                                 of: RateInfoDTO.self)
        return rates.data
    }
}
