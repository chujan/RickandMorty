//
//  RMLocationViewViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 23/05/2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocation()
}

class RMLocationViewViewModel {
    weak var delegate: RMLocationViewViewModelDelegate?
    
    public private (set) var cellViewModels: [ RMLocationTableViewCellViewModel] = []
    private var apiInfo: RMGetAllLocationResponse.Info?
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations = false
    
    private var didFinishPagination: (() -> Void)?
    
    init() {}
    
    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
        
    }
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                    
                }
               
            }
        }
    }
    
    public func fetchAdditionalLocations (){
        print("fetching more characters")
        guard !isLoadingMoreLocations else {
            return
        }
      
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        isLoadingMoreLocations = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
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
               strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                    
                }))
        

                DispatchQueue.main.async {
                    
                    strongSelf.isLoadingMoreLocations = false
                    strongSelf.didFinishPagination?()

                }
                
            case.failure(let failure):
                print(String(describing: failure))
                strongSelf.isLoadingMoreLocations = false
            }
        }
        
    }
    

    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
        
    }
    
    public func fetchLocations() {
        RMService.shared.excute(.listLocationsRequest, expecting: RMGetAllLocationResponse.self) { [weak self] result in
            switch result {
                
            case .success(let model):
                self?.apiInfo = model.info
              
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocation()
                }
                
                
            case .failure(let error):
                print(error)
                
            }
        }
        
        
    }
    private var hasMoreResults: Bool {
        return false
    }
    
}
