//
//  UserUseCasesProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/12/23.
//

import Foundation

protocol UserUseCasesProtocol {
    func getMe() async throws -> User?
    func save(name: String) async throws
    func save(this image: Data) async throws
    func deleteImage() async throws
}
