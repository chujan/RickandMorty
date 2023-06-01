//
//  RMCharacterEpisodeCollectionViewCellModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 17/05/2023.
//

import Foundation
import UIKit

protocol RMEpisodeDataRender {
    var name: String { get }
    var air_date: String {get}
    var episode: String {get}
}


class RMCharacterEpisodeCollectionViewCellModel: Hashable,Equatable {
    
    
    private let episodeDataUrl: URL?
    
    private var isFetching = false
    public let borderColor: UIColor
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue ) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor  = borderColor
    }
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
        
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                self.dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else {
            return
        }
        isFetching = true
        RMService.shared.excute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
                
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
                
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
       
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    static func == (lhs: RMCharacterEpisodeCollectionViewCellModel, rhs: RMCharacterEpisodeCollectionViewCellModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
