//
//  FilmService.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation
import PromiseKit

struct FilmService {

    func getFilm( with id: Int, completion: @escaping (Swift.Result<SWFilm, Error>) -> Void) {
        firstly {
            NetworkManager().fetchFilm(with: id)
        }.then { film in
            NetworkManager().fetchCharacters(with: film.characterURLStrings).map { (film, $0) }
        }.done { film, characters in
            let swFilm = SWFilm(title: film.title, episodeID: film.episodeID, characters: characters)
            completion(.success(swFilm))
        }.catch { error in
            completion(.failure(error))
        }
    }

}
