//
//  RateDTO.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 10/12/23.
//

import Foundation

struct RateDTO: Codable {
    var id: String
    var symbol: String
    var currencySymbol: String?
    var type: String
    var rateUsd: String
}
