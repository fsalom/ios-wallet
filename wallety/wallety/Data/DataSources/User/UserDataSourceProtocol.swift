//
//  UserDataSourceProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/12/23.
//

import Foundation

protocol UserDataSourceProtocol {
    func getMe() async throws -> UserDTO?
    func save(name: String) async throws
}