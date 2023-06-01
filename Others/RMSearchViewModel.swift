//
//  RMSearchViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 24/05/2023.
//

import Foundation
class RMSearchViewModel {
    
    private var searchResultHandler:((RMSearchResultViewModel) -> Void)?
    private var searchResultModel: Codable?
    
    private var searchText = ""
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    private var noResultHandler:(() -> Void)?
    
    
   
    
    let config: RMSearchViewController.Config
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    public func registerSearchResultsHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultHandler(_ block: @escaping () -> Void) {
        self.noResultHandler = block
    }
    
    
    public func executeSearch() {
//        guard searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
//            return
//        }
       
     
            
       
            
        var queryParams: [URLQueryItem] = [
        
            
            (URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
            
            ]
            
       
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
            
            
        }))
        
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        
        switch config.type.endpoint {
        case.character:
            makeSearchAPICall(RMGetAllCharacterResponse.self, request: request)
        case.episode:
            makeSearchAPICall(RMGetAllEpisodeResponse.self, request: request)
        case.location:
            makeSearchAPICall(RMGetAllLocationResponse.self, request: request)
        }
        
        
            
          
 

       
        
}
                
 
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.excute(request, expecting: type) { [weak self] result in
                switch result {
                    
                case .success(let model):
                    self?.processSearchResult(model: model)
                case .failure:
                    self?.handleNoResult()
                    break
                }
            }
        
    }
    
    private func processSearchResult(model: Codable){
        var resultsVM: RMSearchResultViewType?
        var nextUrl: String?
        if let characterResults = model as? RMGetAllCharacterResponse {
           
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name, characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
            }))
            nextUrl   = characterResults.info.next
            
        }
        else if let locationResults = model as? RMGetAllLocationResponse{
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
                
            }))
            nextUrl = locationResults.info.next
            
            
        }
        else if let episodeResults = model as? RMGetAllEpisodeResponse{
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellModel(episodeDataUrl: URL(string: $0.url))
                
            }))
            nextUrl = episodeResults.info.next
            
        }
        if let results = resultsVM {
            self.searchResultModel = model
            let vm = RMSearchResultViewModel(results: results, next: nextUrl)
            self.searchResultHandler?(vm)
        }
        else {
            handleNoResult()
            
        }
        
        
    }
    private func handleNoResult() {
       noResultHandler?()
        
    }

    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
        
        
    }
    
    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func characterSearchResult(at index: Int) -> RMCharacter? {
        guard let searchModel = searchResultModel as? RMGetAllCharacterResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    public func episodeSearchResult(at index: Int) -> RMEpisode? {
        guard let searchModel = searchResultModel as? RMGetAllEpisodeResponse else {
            return nil
        }
        return searchModel.results[index]
    }
    
    
    
}
