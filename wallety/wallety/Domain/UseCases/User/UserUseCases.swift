//
//  UserUseCases.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/12/23.
//

import Foundation

class UserUseCases: UserUseCasesProtocol {
    var repository: UserRepositoryProtocol

    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }

    func getMe() async throws -> User? {
        try await self.repository.getMe()
    }

    func save(name: String) async throws {
        try await self.repository.save(name: name)
    }

    func save(this image: Data) async throws {
        try await self.repository.save(this: image)
    }
}
