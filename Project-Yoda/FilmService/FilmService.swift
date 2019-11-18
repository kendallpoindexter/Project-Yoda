//
//  FilmService.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation
import PromiseKit

struct CharacterService {

    func getCharacters(with pageNumber: Int, completion: @escaping (Swift.Result<SWCharacters,Error>) -> Void) {
        firstly {
            NetworkManager().fetchCharacters(with: pageNumber)
        }.then { apiCharacters in
            NetworkManager().fetchSWCharacters(with: apiCharacters.results)
        }.done { swCharacters in
            let swCharacters = SWCharacters(characters: swCharacters)
            completion(.success(swCharacters))
        }.catch { error in
            completion(.failure(error))
        }

    }

}


