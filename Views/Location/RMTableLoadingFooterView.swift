//
//  RMTableLoadingFooterView.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 29/05/2023.
//

import UIKit

class RMTableLoadingFooterView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(spinner)
        spinner.startAnimating()
        addContraints()
    }
    
   
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func  addContraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.heightAnchor.constraint(equalToConstant: 55),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            
           
        ])
    }
}
