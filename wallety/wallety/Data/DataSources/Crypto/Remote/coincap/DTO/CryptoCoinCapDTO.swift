//
//  CryptoCoinCapDTO.swift
//  wallety
//
//  Created by Fernando Salom Carratala on 4/12/23.
//

import Foundation

struct CryptoCoinCapDTO: Codable {
    var id: String
    var symbol: String
    var name: String
    var priceUsd: String
    var changePercent24Hr: String
}
