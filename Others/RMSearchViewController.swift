//
//  RMSearchViewController.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 20/05/2023.
//

import UIKit

class RMSearchViewController: UIViewController {
    
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var endpoint: RMEndpoint {
                switch self {
                
                case .character:
                    return .character
                case .episode:
                    return.episode
                case .location:
                    return.location
                }
                
            }
            
            
            
            var title: String {
                switch self {
                case.character:
                    return "Search Characters"
                case.location:
                    return  "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }
        let type: `Type`
    }
    
   
    private let viewModel: RMSearchViewModel
    private let searchView : RMSearchView
    init(config: Config) {
        let viewModel = RMSearchViewModel(config: config)
        self.viewModel = viewModel
    
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraint()
        didTapExcuteSearch()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExcuteSearch))
        searchView.delegate = self
        

       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    @objc private func didTapExcuteSearch() {
        viewModel.executeSearch()
        
    }
    
    
    private func  addConstraint() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }


}

extension RMSearchViewController: RMSearchViewDelegate {
  
  
    
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let vc = RMSearchOptionViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
            
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode) {
        let vc = RMEpisodeDetailViewController(url: URL(string: episode.url))
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
  
    
    
   
    
    
}
