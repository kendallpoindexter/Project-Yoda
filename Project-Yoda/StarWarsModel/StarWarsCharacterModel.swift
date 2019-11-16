//
//  StarWarsCharacterModel.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation

class SWCharacter {
    var name: String
    var gender: String
    var homeworld: String
    var species: [Species]

    init(name: String, gender: String, homeworld: String, species: [Species]) {
        self.name = name
        self.gender = gender
        self.homeworld = homeworld
        self.species = species
    }
}
