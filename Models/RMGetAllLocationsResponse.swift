//
//  RMGetAllLocationsResponse.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 23/05/2023.
//

import Foundation
struct RMGetAllLocationResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages:Int
        let next: String?
        let prev: String?
        
    }
    let info: Info
    let results: [RMLocation]
    
        
    }
