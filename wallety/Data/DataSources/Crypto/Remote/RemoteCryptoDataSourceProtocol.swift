protocol RemoteCryptoDataSourceProtocol {
    func getTopCryptos() async throws -> [CryptoCoinCapDTO]
}
