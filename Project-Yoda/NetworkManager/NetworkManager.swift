//
//  NetworkManager.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation
import PromiseKit

struct NetworkManager {

    func fetchCharacters(with pageNumber: Int) -> Promise<APICharactersResponse> {
        let urlString = "https://swapi.co/api/people/?page=\(pageNumber)"

        return Promise { seal in
            firstly {
                fetchObjectFromData(with: urlString, type: APICharactersResponse.self)
            }.done { characters in
                seal.fulfill(characters)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

    func fetchSWCharacters( with characters: [APICharacter]) -> Promise<[SWCharacter]> {
        let swCharacterPromises = characters.map {
            fetchSWCharacter(with: $0)
        }

        return Promise { seal in
            firstly {
                when(fulfilled: swCharacterPromises)
            }.done { swCharacters in
                seal.fulfill(swCharacters)
            }.catch { error in
                seal.reject(error)
            }
        }

    }

   private func fetchSWCharacter( with character: APICharacter) -> Promise<SWCharacter> {
        return Promise { seal in
            firstly {
                fetchPlanet(with: character.homeworld)
            }.then { planet in
                self.fetchFilms(with: character.films).map{(planet, $0)}
            }.then { planet, films in
                self.fetchSpecies(with: character.species).map {(planet, films, $0)}
            }.done { planet, films, species in
                let swCharacter = SWCharacter(name: character.name, gender: character.gender, homeworld: planet.name, films: films, species: species)
                seal.fulfill(swCharacter)
            }.catch { error in
                seal.reject(error)
            }

        }
    }

    private func fetchPlanet(with urlString: String) -> Promise<Planet> {
        return Promise { seal in
            firstly {
                fetchObjectFromData(with: urlString, type: Planet.self)
            }.done { planet in
                seal.fulfill(planet)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

   private func fetchFilms( with urlString: [String]) -> Promise<[Film]> {
        let filmPromises = urlString.map {
            fetchObjectFromData(with: $0, type: Film.self)
        }
        return Promise { seal in
            firstly {
                when(fulfilled: filmPromises)
            }.done { films in
                seal.fulfill(films)
            }.catch { error in
                seal.reject(error)
            }

        }
    }

   private func fetchSpecies(with urlStrings: [String]) -> Promise<[Species]> {
        return Promise { seal in
            let speciesPromises = urlStrings.map {
                fetchObjectFromData(with: $0, type: Species.self)
            }
            firstly {
                when(fulfilled: speciesPromises)
            }.done { species in
                seal.fulfill(species)
            }.catch { error in
                seal.reject(error)
            }
        }
    }

   private func fetchObjectFromData<T: Decodable>(with urlString: String, type: T.Type) -> Promise<T> {
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        return Promise { seal in
            guard let url = url else { return }
            let task = session.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                }else if let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode{
                    guard let data = data, let decodedData = self.parseData(with: data, type: type) else { return }
                    seal.fulfill(decodedData)
                }
            }
            task.resume()
        }
    }
    
    private func parseData<T: Decodable>(with data: Data, type: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        } catch {
            print("Failure Parsing Error \(error)")
            return nil
        }
    }
}
