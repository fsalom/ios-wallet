//
//  CryptoRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol CryptoRepositoryProtocol {
    func getTopCrypto() async throws -> [Crypto]
}
