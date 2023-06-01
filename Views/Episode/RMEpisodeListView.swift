//
//  RMEpisodeListView.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 20/05/2023.
//

import Foundation
import UIKit
protocol RMEpisodeListViewDelegate: AnyObject {
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode : RMEpisode)
    
    
}


class RMEpisodeListView: UIView {
    public weak var delegate: RMEpisodeListViewDelegate?
    
    private let viewModel = RMEpisodeListViewViewModel()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
        
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
       
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(collectionView, spinner)
     
        addConstraints()
        
        setUpCollectionView()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchEpisodes()
      
        
        
        translatesAutoresizingMaskIntoConstraints = false
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
         spinner.widthAnchor.constraint(equalToConstant: 100),
          spinner.heightAnchor.constraint(equalToConstant: 100),
          spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
          spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     
         collectionView.topAnchor.constraint(equalTo: topAnchor),
         collectionView.leftAnchor.constraint(equalTo: leftAnchor),
         collectionView.rightAnchor.constraint(equalTo: rightAnchor),
         collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func  setUpCollectionView() {
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel

          
        
        
    }
    
}

extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {
    
    func didLoadInitialEpisode() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
        
    }
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
    
  
    
    func didSelectEpisode(_ episode: RMEpisode) {
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
    
    
    
   
    
    
}


