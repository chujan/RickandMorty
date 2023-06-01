//
//  RMEndpoint.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 01/03/2023.
//

import Foundation
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    case character
    case location
    case episode
}
