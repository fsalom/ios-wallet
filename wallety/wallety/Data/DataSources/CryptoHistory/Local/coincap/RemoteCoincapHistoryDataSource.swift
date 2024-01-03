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
        let queryItems = [URLQueryItem(name: "interval", value: "d1")]
        var urlComps = URLComponents(string: "https://api.coincap.io/v2/assets/\(crypto.lowercased().replacingOccurrences(of: " ", with: "-"))/history")!
        urlComps.queryItems = queryItems
        guard let url = urlComps.url else { throw NetworkError.badRequest }
        let request = URLRequest(url: url)
        let pagination = try await networkManager.call(this: request,
                                                   of: CryptoHistoryDataDTO.self)
        return pagination.data
    }
}
