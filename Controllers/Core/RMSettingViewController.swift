//
//  RMSettingViewController.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 26/02/2023.
//

import UIKit
import StoreKit
import SwiftUI
import SafariServices

final class RMSettingViewController: UIViewController {
    
   
    private var settingsView: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Setting"
        addSwiftUIController()

        
    }
    
    func addSwiftUIController() {
        
        
    let settingsView =  UIHostingController(rootView: RMSettingsView(viewModel: RMSettingViewViewModel (cellViewModels: RMSettingOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0) {[weak self] option in
            self?.handleTap(option: option)
            
        }
           
       })
                                                                                                  
       )
       )
   )
        
        addChild(settingsView)
        settingsView.didMove(toParent: self)
        view.addSubview(settingsView.view)
        settingsView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsView.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsView.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            
            settingsView.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            settingsView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
        ])
        self.settingsView = settingsView
    }
    
    private func handleTap(option: RMSettingOption) {
        guard Thread.main.isMainThread else {
            return
        }
        if let url = option.targetUrl {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
            
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
            
        }
        
    }

    

}
