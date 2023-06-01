//
//  RMLocationViewController.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 26/02/2023.
//

import UIKit

final class RMLocationViewController: UIViewController , RMLocationViewViewModelDelegate, RMLocationViewDelegate{
    
    
    private let primaryView = RMLocationView()
    
    private let viewModel =  RMLocationViewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(primaryView)
        view.backgroundColor = .systemBackground
        title = "Location"
        addShareButton()
        primaryView.delegate = self
        addContraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
        didFetchInitialLocation()
        
        
    }
    
    private func addShareButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        
        
    }
    func didFetchInitialLocation() {
        primaryView.configure(with: viewModel)
    }
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
