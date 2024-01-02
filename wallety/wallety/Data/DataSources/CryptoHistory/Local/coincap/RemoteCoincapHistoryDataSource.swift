//
//  CoincapRemoteDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 2/1/24.
//

import Foundation

class RemoteCoincapHistoryDataSource: RemoteCryptoHistoryDataSourceProtocol {
    var networkManager: RemoteManagerProtocol

    init(networkManager: RemoteManagerProtocol) {
        self.networkManager = networkManager
    }

    func getHistory(for crypto: String) async throws -> [CryptoHistoryDTO] {
        guard let url = URL(string: "https://api.coincap.io/v2/assets/\(crypto)/?interval=d1") else {
            throw NetworkError.badURL
        }
        let request = URLRequest(url: url)
        let pagination = try await networkManager.call(this: request,
                                                   of: CryptoHistoryDataDTO.self)
        return pagination.data
    }
}
