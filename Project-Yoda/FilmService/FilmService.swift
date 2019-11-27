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

    func getCharacters(with pageNumber: Int, completion: @escaping (Swift.Result<([SWCharacter],Int),Error>) -> Void) {
        firstly {
            NetworkManager().fetchCharacters(with: pageNumber)
        }.then { response in
            NetworkManager().fetchSWCharacters(with: response.results).map {($0, response.count)}
        }.done { swCharacters, characterCount in
            completion(.success((swCharacters, characterCount)))
        }.catch { error in
            completion(.failure(error))
        }

    }

}


