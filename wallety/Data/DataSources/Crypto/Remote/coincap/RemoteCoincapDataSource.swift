import Foundation

class RemoteCryptoCoinCapDataSource: RemoteCryptoDataSourceProtocol {
    var networkManager: RemoteManagerProtocol

    init(networkManager: RemoteManagerProtocol) {
        self.networkManager = networkManager
    }

    func getTopCryptos() async throws -> [CryptoCoinCapDTO] {
        guard let url = URL(string: "https://api.coincap.io/v2/assets") else {
            throw NetworkError.badURL
        }
        let request = URLRequest(url: url)
        let crypto = try await networkManager.call(this: request,
                                                   of: CryptoCoinCapDataDTO.self)
        return crypto.data
    }
}
