//
//  RMFooterLoadingCollectionReusableView.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 15/05/2023.
//

import UIKit

class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    
    static let identifier = "RMFooterLoadingCollectionReusableView"
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addContraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
             spinner.heightAnchor.constraint(equalToConstant: 100),
             spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
             spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
    }
    
    public func startAnimating() {
        spinner.startAnimating()
        
    }
    
    
        
}
