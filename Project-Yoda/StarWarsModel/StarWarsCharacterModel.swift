//
//  StarWarsCharacterModel.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation

//class SWCharacters {
//    var characters: [SWCharacter]
//    var totalCharacterCount: Int
//
//    init(characters: [SWCharacter], totalCharacterCount: Int) {
//        self.characters = characters
//        self.totalCharacterCount = totalCharacterCount
//    }
//}

class SWCharacter {
    var name: String
    var gender: String
    var homeworld: String
    var films: [Film]
    var species: [Species]

    init(name: String, gender: String, homeworld: String, films: [Film], species: [Species]) {
        self.name = name
        self.gender = gender
        self.homeworld = homeworld
        self.films = films
        self.species = species
    }
}
