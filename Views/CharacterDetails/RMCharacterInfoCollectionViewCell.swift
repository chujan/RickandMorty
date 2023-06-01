//
//  RMInfoCollectionViewCell.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 17/05/2023.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterInfoCollectionViewCell"
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
       
        return label
        
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
       
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
        
    }()
    
    private let iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "globe.americas")
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
        
        
    }()
    
    private let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 0
        contentView.addSubviews(titleContainerView,valueLabel, iconImageView)
        titleContainerView.addSubview(titleLabel)
        contentView.layer.masksToBounds = true
        setUpContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func setUpContraints() {
        NSLayoutConstraint.activate([
            titleContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            titleLabel.leftAnchor.constraint(equalTo: titleContainerView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: titleContainerView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: titleContainerView.heightAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 20),
            
            
            valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor)
            
            
        ])
     
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = nil
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = .label
        titleLabel.textColor = .label
       
        
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.iconImage
        iconImageView.tintColor = viewModel.type.tintColor
        titleLabel.textColor = viewModel.tintColor
        
        
    }
    
}
