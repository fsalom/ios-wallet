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
    func set(_ String: String, _ value: Any?)
    func get(stringFor: String) -> String?
    func get(intFor: String) -> Int
    func get(doubleFor: String) -> Double
    func get(floatFor: String) -> Float
    func get(boolFor: String) -> Bool
    func get(arrayFor: String) -> [Any]?
    func get(anyFor: String) -> Any?
    func get(dictionaryArrayFor: String) -> [String: [Any]]?
    func get(dictionaryFor: String) -> [String: Any]?
    func clear()
}
