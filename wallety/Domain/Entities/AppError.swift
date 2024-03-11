//
//  AppError.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/3/24.
//

import Foundation

enum AppError: Error {
    case custom(String, String)
    case generic(String)

    var localizedDescription: String {
        switch self {
        case .custom(_, let description):
            return description
        case .generic(let error):
            return "Se ha producido un error en la carga de información: Más detalles: \(error)"
        }
    }

    var localizedTitle: String {
        switch self {
        case .custom(let title, _):
            return title
        case .generic(_):
            return "Se ha producido un error"
        }
    }

    func getTitleAndDescription() -> (String, String) {
        switch self {
        case .custom(let title, let description):
            return (title, description)
        case .generic(_):
            return (self.localizedTitle, self.localizedTitle)
        }
    }
}
