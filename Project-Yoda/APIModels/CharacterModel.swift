//
//  CharacterModel.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation

struct APICharacters: Decodable {
    let next: String?
    let previous: String?
    let results: [APICharacter]
}

struct APICharacter: Decodable {
    let name: String
    let gender: String
    let homeworld: String
    let films: [String]
    let species: [String]
}

extension APICharacter {
    enum CharacterCodingKeys: String, CodingKey {
        case name
        case gender
        case homeworld
        case films
        case species
    }
}
