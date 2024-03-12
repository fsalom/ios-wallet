//
//  Currency.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 11/3/24.
//

import Foundation

struct Currency: Identifiable {
    var id: String = UUID().uuidString
    var icon: String
    var name: String
    var symbol: String
    var selected: Bool = false
}
