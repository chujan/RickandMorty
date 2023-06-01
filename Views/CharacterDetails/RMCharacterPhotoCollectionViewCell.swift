//
//  RMPhotoCollectionViewCell.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 17/05/2023.
//

import UIKit

class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMCharacterPhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        setUpContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func setUpContraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ])
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
                
            case .success(let data):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: data)
                }
                
            case .failure:
                break
                
            }
        }
        
    }
    
}
