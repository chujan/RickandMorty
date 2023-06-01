//
//  RMCharacterDetailViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 13/05/2023.
//

import UIKit

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    public var episodes: [String] {
        character.episode
    }
    
    
    enum SectionType {
        case photo(viewModel: RMCharacterPhotoCollectionViewCellModel)
        case information(viewModels: [RMCharacterInfoCollectionViewCellModel])
        case episodes(viewModels: [RMCharacterEpisodeCollectionViewCellModel])
    }
    
    public var  sections: [SectionType] = []
    
    
    init(character: RMCharacter) {
        self.character = character
        setUpSections()
        
    }
    private func setUpSections() {
        sections = [
            .photo(viewModel: .init(imageUrl: URL(string: character.image))),
            .information(viewModels: [
                .init(type: .status, value:character.status.text),
                .init(type:.gender, value: character.gender.rawValue),
                .init(type: .type, value:character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created, value: character.created),
                .init(type: .episodeCount, value: "\(character.episode.count)"),
                
            ]),
            
                .episodes(viewModels: character.episode.compactMap({
                    return RMCharacterEpisodeCollectionViewCellModel(episodeDataUrl: URL(string: $0))
                }))
            
            ]
        
    }
    
    public var requestUrl: URL? {
        return URL(string: character.url)
    }
    
    public var title: String {
        character.name.uppercased()
    }
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    
    public func createInfoSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIDevice.isiphone ? 0.5 : 0.25), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)), subitems: UIDevice.isiphone ? [item, item] : [item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        return section
    }
    
    
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(UIDevice.isiphone ? 0.8 : 0.4), heightDimension: .absolute(150)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    
    public func fetchCharacterData() {
        print(character.url)
        guard let url = requestUrl,
              let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.excute(request, expecting: RMCharacter.self) { result in
            switch result {
            case.success(let success):
                print(String(describing: success))
            case.failure(let failure):
                print(String(describing: failure))
            }
        }
       
    }
}

