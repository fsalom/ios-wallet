//
//  UserRepository.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/12/23.
//

import Foundation

class UserRepository: UserRepositoryProtocol {
    var datasource: UserDataSourceProtocol

    init(datasource: UserDataSourceProtocol) {
        self.datasource = datasource
    }

    func getMe() async throws -> User? {
        try await self.datasource.getMe()?.toDomain()
    }

    func save(name: String) async throws {
        try await self.datasource.save(name: name)
    }
}

fileprivate extension UserDTO {
    func toDomain() -> User {
        User(name: name)
    }
}
