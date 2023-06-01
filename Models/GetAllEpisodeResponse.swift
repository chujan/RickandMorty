//
//  GetAllEpisodeResponse.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 20/05/2023.
//

import Foundation
struct RMGetAllEpisodeResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages:Int
        let next: String?
        let prev: String?
        
    }
    let info: Info
    let results: [RMEpisode]
    
        
    }
