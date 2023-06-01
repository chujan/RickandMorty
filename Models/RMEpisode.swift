//
//  RMEpisode.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 02/03/2023.
//

import Foundation
struct RMEpisode: Codable, RMEpisodeDataRender {
    var episode: String
    
    let id: Int
    let name: String
    let air_date: String
    let characters: [String]
    let url: String
    let created: String
}
