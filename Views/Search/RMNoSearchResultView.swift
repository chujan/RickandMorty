//
//  RMNoSearchResultView.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 24/05/2023.
//

import UIKit

class RMNoSearchResultView: UIView {
    private let viewModel = RMNoSearchResultViewViewModel()
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(iconView, label)
        isHidden = true
        addContraints()
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func  addContraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.heightAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.leftAnchor .constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.bottomAnchor .constraint(equalTo: bottomAnchor),
            label.heightAnchor .constraint(greaterThanOrEqualToConstant: 60),
            label.topAnchor .constraint(equalTo: iconView.bottomAnchor, constant: 10),
        ])
        
    }
    
    private func configure() {
        label.text = viewModel.title
        iconView.image = viewModel.image
    }

   

}
