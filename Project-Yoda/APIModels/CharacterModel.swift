//
//  CharacterModel.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation

struct APICharacter: Decodable {
    let name: String
    let gender: String
    let homeworld: String
    let species: [String]
}

extension APICharacter {
    enum CharacterCodingKeys: String, CodingKey {
        case name
        case gender
        case homeworld
        case species
    }
}
