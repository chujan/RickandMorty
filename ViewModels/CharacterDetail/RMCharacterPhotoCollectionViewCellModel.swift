//
//  RMCharacterPhotoCollectionViewCellModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 17/05/2023.
//

import Foundation
class RMCharacterPhotoCollectionViewCellModel{
    
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
            
        }
        RMImageLoader.shared.downloadImage(imageUrl, completion: completion)
    }
    
    
}
