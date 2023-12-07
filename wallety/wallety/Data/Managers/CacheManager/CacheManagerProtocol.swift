//
//  CacheManagerProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 7/12/23.
//

import Foundation

protocol CacheManagerProtocol {
    func save<T: Codable>(objectFor: String, this data: T)
    func retrieve<T: Decodable>(objectFor: String, of type: T.Type) -> T?
    func clear()
}
