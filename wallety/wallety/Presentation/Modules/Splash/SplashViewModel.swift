//
//  SplashViewModel.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 28/12/23.
//

import Foundation

class SplashViewModel: ObservableObject {
    var userUseCases: UserUseCasesProtocol

    @Published var currentScreen: Screen = .none

    init(userUseCases: UserUseCasesProtocol) {
        self.userUseCases = userUseCases
    }

    func getScreen() async throws -> Screen {
        guard let _ = try await userUseCases.getMe() else {
            return .onBoarding
        }
        return .app
    }

    func load() {
        Task {
            do {
                let screen = try await getScreen()
                await MainActor.run {
                    currentScreen = screen
                }
            } catch {

            }
        }
    }
}
