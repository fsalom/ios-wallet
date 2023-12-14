//
//  CacheRateDTO.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 13/12/23.
//

import Foundation

struct CacheRateDTO: Codable {
    var symbol: String
    var currencySymbol: String?
    var rateUsd: String
}
