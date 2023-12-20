//
//  CryptoRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol CryptoRepositoryProtocol {
    func getCrypto(with symbol: String) async throws -> Crypto?
    func getCryptos() async throws -> [Crypto]
}
