//
//  FilmModel.swift
//  Project-Yoda
//
//  Created by Kendall Poindexter on 11/16/19.
//  Copyright © 2019 Kendall Poindexter. All rights reserved.
//

import Foundation

struct Film: Decodable {
    let title: String
    let episodeID: Int

    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
    }
}
