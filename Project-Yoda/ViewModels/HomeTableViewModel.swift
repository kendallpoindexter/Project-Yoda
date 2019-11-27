//
//  HomeTableViewModel.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/18/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation

class HomeTableViewModel {
    var currentPage = 1
    var characters = [SWCharacter]()
    var totalCharacterCount: Int = 0
    var isFetchInProgress = false


    func getCharacters( completion: @escaping (Result<[IndexPath], Error>) -> Void) {
        //Why is this guard neccesary 
        guard !isFetchInProgress else { return }
        isFetchInProgress = true

        CharacterService().getCharacters(with: currentPage) { (result) in
            switch result {
            case let .success(swCharacters, count):
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.characters.append(contentsOf: swCharacters)
                    self.totalCharacterCount = count

                    if self.currentPage > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: swCharacters)
                        completion(.success(indexPathsToReload))
                    } else {
                        completion(.success([]))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }

            self.isFetchInProgress = false
        }
    }

    func calculateIndexPathsToReload(from newCharacters: [SWCharacter]) -> [IndexPath] {
        let startIndex = characters.count - newCharacters.count
        let endIndex = startIndex + newCharacters.count
        return (startIndex..<endIndex).map {IndexPath(row: $0, section: 0)}
    }

}
