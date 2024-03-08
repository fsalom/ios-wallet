//
//  Container.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 5/12/23.
//

import Foundation
import SwiftData

class Container {
    static let shared = Container()

    private var homeView: HomeView?
    private var topCryptosView: TopCryptosView?

    @MainActor 
    func getHomeView(with container: ModelContainer) -> HomeView {
        guard let homeView else {
            let homeView = HomeBuilder().build(with: container)
            Container.shared.homeView = homeView
            return homeView
        }
        return homeView
    }

    func getTopCryptosView(with container: ModelContainer) -> TopCryptosView {
        guard let topCryptosView else {
            let topCryptosView = TopCryptosBuilder().build(with: container)
            Container.shared.topCryptosView = topCryptosView
            return topCryptosView
        }
        return topCryptosView
    }
}
