//
//  UserMockUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 28/12/23.
//

import Foundation

class UserMockUseCases: UserUseCasesProtocol {
    func getMe() async throws -> User? {
        User(name: "test")
    }
    
    func save(name: String) async throws {
    }

    func save(this image: Data) async throws {
    }
}
