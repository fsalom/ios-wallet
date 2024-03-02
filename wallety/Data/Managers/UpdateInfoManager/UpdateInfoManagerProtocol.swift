//
//  UpdateInfoManagerProtocol.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 27/1/24.
//

import Foundation

protocol UpdateInfoManagerProtocol {
    func shouldUpdate(this option: String, after seconds: Int) -> Bool
    func setDate(for option: String, isResetNeeded: Bool)
}
