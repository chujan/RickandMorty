//
//  RMEpisodeistViewViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 20/05/2023.
//

import Foundation
import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    func didLoadInitialEpisode()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}
class RMEpisodeListViewViewModel: NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes = false
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemRed,
        .systemPurple,
        .systemGreen,
        .systemOrange,
        .systemYellow,
        .systemPink,
        .systemIndigo,
        .systemMint
        
            
        
    ]
    
    private var episodes: [RMEpisode] = [] {
        didSet {
           // print("Creating viewModels")
            for episode in episodes {
                let viewmodel = RMCharacterEpisodeCollectionViewCellModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .systemBlue)
                
                
               if !cellViewModels.contains(viewmodel) {
                    cellViewModels.append(viewmodel)

                }
               
            }
        }
    }
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellModel] = []
    
    private var apiInfo: RMGetAllEpisodeResponse
        .Info? = nil
    func fetchEpisodes() {
        RMService.shared.excute(.listEpisodesRequests, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            switch result {
            case.success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisode()
                }
                
                
            case.failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalEpisodes(url: URL) {
        print("fetching more characters")
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            print("failed to create request")
            return
        }
        RMService.shared.excute(request, expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case.success(let responseModel):
                print("Pre-update: \(strongSelf.cellViewModels.count)")
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
               
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount+newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap ({
                    return IndexPath(row: $0, section: 0)
                })
                print(indexPathToAdd)
                strongSelf.episodes .append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                    strongSelf.isLoadingMoreEpisodes = false
                   
                }
                
            case.failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreEpisodes = false
            }
        }
        
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return  apiInfo?.next != nil
    }
    
}
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
        
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width-20
        return CGSize(width: width, height:  100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
    
    
}

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator, !isLoadingMoreEpisodes, let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString) else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
               // print("should ")
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}

