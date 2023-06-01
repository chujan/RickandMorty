//
//  RMSearchResultViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 27/05/2023.
//

import Foundation
 class RMSearchResultViewModel {
     
    public private(set) var results: RMSearchResultViewType
     
   private var next: String?
     init(results: RMSearchResultViewType, next: String?) {
         self.results = results
         self.next = next
     }
     
    public private(set) var isLoadingMoreResults = false
     
    public var shouldShowLoadMoreIndicators: Bool {
        return next != nil
    }
     
     public func fetchAdditionalLocations (completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void){
        
        guard !isLoadingMoreResults else {
            return
        }
      
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            print("failed to create request")
            return
        }
        RMService.shared.excute(request, expecting: RMGetAllLocationResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case.success(let responseModel):
                
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)

                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case.locations(let existingResults):
                     newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                   
                case.characters:
                    break
                case.episodes:
                    break
                }
        

                DispatchQueue.main.async {
                    
                    strongSelf.isLoadingMoreResults = false
                    completion(newResults)
                   
                  //  strongSelf.didFinishPagination?()

                }
                
            case.failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreResults = false
            }
        }
        
    }
     public func fetchAdditionalResults (completion: @escaping ([any Hashable]) -> Void){
         
         guard !isLoadingMoreResults else {
             return
         }
         
         
         guard let nextUrlString = next,
               let url = URL(string: nextUrlString) else {
             return
         }
         isLoadingMoreResults = true
         
         guard let request = RMRequest(url: url) else {
             isLoadingMoreResults = false
             print("failed to create request")
             
             return
         }
         
         switch results {
             
         case .characters(let  existingResults ):
             RMService.shared.excute(request, expecting:RMGetAllCharacterResponse.self) { [weak self] result in
                 guard let strongSelf = self else {
                     return
                 }
                 switch result {
                 case.success(let responseModel):
                     
                     let moreResults = responseModel.results
                     let info = responseModel.info
                     strongSelf.next = info.next
                     let additionalResult = moreResults.compactMap({
                         return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
                         
                     })
                     var newResults: [RMCharacterCollectionViewCellViewModel] = []
                   
                         newResults = existingResults + additionalResult
                         strongSelf.results = .characters(newResults)
                         
                  
                     
                     DispatchQueue.main.async {
                         
                         strongSelf.isLoadingMoreResults = false
                         completion(newResults)
                         
                         //  strongSelf.didFinishPagination?()
                         
                     }
                     
                 case.failure(let failure):
                     print(String(describing: failure))
                     strongSelf.isLoadingMoreResults = false
                 }
             }
             
         case .episodes(let existingResults):
             RMService.shared.excute(request, expecting:RMGetAllEpisodeResponse.self) { [weak self] result in
                 guard let strongSelf = self else {
                     return
                 }
                 switch result {
                 case.success(let responseModel):
                     
                     let moreResults = responseModel.results
                     let info = responseModel.info
                     strongSelf.next = info.next
                     let additionalResults = moreResults.compactMap({
                         return RMCharacterEpisodeCollectionViewCellModel(episodeDataUrl: URL(string: $0.url))
                         
                     })
                     var newResults: [RMCharacterEpisodeCollectionViewCellModel] = []
                    
                         newResults = existingResults + additionalResults
                         strongSelf.results = .episodes(newResults)
                         
                    
                     
                     DispatchQueue.main.async {
                         
                         strongSelf.isLoadingMoreResults = false
                         completion(newResults)
                         
                         //  strongSelf.didFinishPagination?()
                         
                     }
                     
                 case.failure(let failure):
                     print(String(describing: failure))
                     strongSelf.isLoadingMoreResults = false
                 }
             }
             
         case .locations(_):
             break
         }
     
             
        
         
        RMService.shared.excute(request, expecting: RMGetAllLocationResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case.success(let responseModel):
                
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)

                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case.locations(let existingResults):
                     newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                   
                case.characters:
                    break
                case.episodes:
                    break
                }
        

                DispatchQueue.main.async {
                    
                    strongSelf.isLoadingMoreResults = false
                    completion(newResults)
                   
                  //  strongSelf.didFinishPagination?()

                }
                
            case.failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreResults = false
            }
        }
        
    }
    
       
}

enum RMSearchResultViewType  {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellModel])
    case locations([RMLocationTableViewCellViewModel])
    
    
}
