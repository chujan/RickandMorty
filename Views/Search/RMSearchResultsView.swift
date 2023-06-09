//
//  RMSearchResultsView.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 27/05/2023.
//

import UIKit

protocol RMSearchResultViewDelegate: AnyObject {
    func rmSearchResultView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
    func rmSearchResultView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int)
    func rmSearchResultView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int)
}

class RMSearchResultsView: UIView {
    
    weak var delegate: RMSearchResultViewDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.identifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
        
    }()
 
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       
        collectionView.isHidden = true
      
      
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
        
    }()
    
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    private var collectionViewCellViewModels: [any Hashable] = []
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
      addSubviews(tableView, collectionView)
        addConstraints()
//        processViewModel()
//        setUpCollectionView()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
            
        }
        
        switch viewModel.results {
            
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
            
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
       
            
            
        }
    }
    
    private func  setUpCollectionView(){
        self.tableView.isHidden = true
        collectionView.reloadData()
        self.collectionView.isHidden = true
        self.collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
       
        
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
        self.locationCellViewModels = viewModels
        tableView.isHidden = false
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.isHidden = true
        
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
           collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
      
        
    }
    public func configure(with viewModel: RMSearchResultViewModel ) {
        self.viewModel = viewModel
        
    }
   

}

extension RMSearchResultsView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.identifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError("Unsupported")
            
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        delegate?.rmSearchResultView(self, didTapLocationAt: indexPath.row)
    }
    
    
}

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let  characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: characterVM)
            
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellModel {
            cell.configure(with: episodeVM)
        }
     
        return cell
    
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {
            return
            
        }
        
        switch viewModel.results {
            
        case .characters:
            delegate?.rmSearchResultView(self, didTapCharacterAt: indexPath.row)
        case .locations:
          break
        case .episodes:
            delegate?.rmSearchResultView(self, didTapEpisodeAt: indexPath.row)
       
            
            
        }
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            
            let width = UIDevice.isiphone ? (bounds.width-30)/2 :  (bounds.width-50)/4
            return CGSize(width: width, height: width * 1.5)
            
        }
        let width = UIDevice.isiphone ? bounds.width-20 : (bounds.width-30)/2
        return CGSize(width: width, height: 100)
        
       
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        if  let viewModel = viewModel,
            viewModel.shouldShowLoadMoreIndicators {
            footer.startAnimating()
            
        }
    
       
        return footer
        
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicators else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    
}

extension RMSearchResultsView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty {
            handleLocationPagination(scrollView: scrollView)
           
        } else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
            
        }
     
       
    }
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel, !collectionViewCellViewModels.isEmpty, viewModel.shouldShowLoadMoreIndicators, !viewModel.isLoadingMoreResults else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in

            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
    
                viewModel.fetchAdditionalResults { [weak self] newResult in
                    guard let strongSelf = self else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.tableView.tableFooterView = nil
                        let originalCount = strongSelf.collectionViewCellViewModels.count
                        let newCount = (newResult.count - originalCount)
                        let total = originalCount + newCount
                        let startingIndex = total - newCount
                        let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                            return IndexPath(row: $0, section: 0)
                        })
                        print("shoud: \(newResult.count)")
                        strongSelf.collectionViewCellViewModels = newResult
                        strongSelf.collectionView.insertItems(at: indexPathToAdd)
                        
                       
                    }
                    
                    
                    
                }

            }
            t.invalidate()
        }
        
    }
    
    private func handleLocationPagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel, !locationCellViewModels.isEmpty, viewModel.shouldShowLoadMoreIndicators, !viewModel.isLoadingMoreResults else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in

            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height

            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showTableLoadingIndicator()
                }
                viewModel.fetchAdditionalLocations { [weak self] newResult in
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResult
                    self?.tableView.reloadData()
                    
                }

            }
            t.invalidate()
        }
    }

private func showTableLoadingIndicator() {

        let footer = RMTableLoadingFooterView(frame:  CGRect(x: 0, y: 0, width: frame.size.width, height: 100))


        tableView.tableFooterView = footer
    }




    }
    
           
