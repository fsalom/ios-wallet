//
//  RemoteManagerProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

protocol RemoteManagerProtocol {
    func call<T: Decodable>(this url: URLRequest, of type: T.Type) async throws -> T
}
