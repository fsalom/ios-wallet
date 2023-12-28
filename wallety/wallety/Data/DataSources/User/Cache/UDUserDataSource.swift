//
//  UDUserDataSource.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/12/23.
//

import Foundation

class UDUserDataSource: UserDataSourceProtocol {
    var userDefaultsManager: CacheManagerProtocol

    let keyName: String = "KEY_USER_WALLET"

    init(userDefaultsManager: CacheManagerProtocol) {
        self.userDefaultsManager = userDefaultsManager
    }

    func getMe() async throws -> UserDTO? {
        userDefaultsManager.retrieve(objectFor: keyName, of: UserDTO.self)
    }

    func save(name: String) async throws {
        if var me = try await getMe() {
            me.name = name
            userDefaultsManager.save(objectFor: keyName, this: me)
        } else {
            let me = UserDTO(name: name)
            userDefaultsManager.save(objectFor: keyName, this: me)
        }
    }
}
