//
//  RMEpisodeDetailViewViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 20/05/2023.
//

import UIKit

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetchEpisodeDetails()
}

class RMEpisodeDetailViewViewModel {
    
    
    private let endpointUrl: URL?
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
            
        }
        
    }
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
   public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = []
    
  
    
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        
    }
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
        
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple  else {
            return
        }
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if  let date = RMCharacterInfoCollectionViewCellModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInfoCollectionViewCellModel.shortDateFormatter.string(from: date) 
            episode.created
            
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name, characterStatus: character.status, characterImageUrl: URL(string: character.image))
            }))
        ]
        
    }
    
    public func fetchEpisodeData() {
        guard let  url = endpointUrl,
              let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.excute(request, expecting: RMEpisode.self) { [weak self]result in
            switch result {
            case.success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case.failure:
                break
            }
        }
        
    }
    private func fetchRelatedCharacters(episode: RMEpisode) {
       
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.excute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                    
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
                )
            
            
        }
    }
   
   
}
