//
//  ProfileViewmodel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 9/12/23.
//

import Foundation

class ProfileViewModel: ObservableObject {

    var useCase: CryptoUseCasesProtocol

    init(useCase: CryptoUseCasesProtocol) {
        self.useCase = useCase
    }

    func clearDB() {
        Task {
            
        }
    }
}
