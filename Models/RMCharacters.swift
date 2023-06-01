//
//  RMCharacters.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 26/02/2023.
//

import Foundation
struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMOrigin
    let image: String
    let location: RMSingleLocation
    let episode: [String]
    let created: String
    let url: String
    
}

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case.alive, .dead:
            return rawValue
        case.unknown:
            return "Unknown"
        }
    }
}


enum RMCharacterGender: String, Codable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown = "unknown"
    
}


