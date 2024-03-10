//
//  AppError.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/3/24.
//

import Foundation

enum AppError: Error {
    case custom(String, String)

    var localizedDescription: String {
        switch self {
        case .custom(_, let description):
            return description
        }
    }

    var localizedTitle: String {
        switch self {
        case .custom(let title, _):
            return title
        }
    }

    func getTitleAndDescription() -> (String, String) {
        switch self {
        case .custom(let title, let description):
            return (title, description)
        }
    }
}
