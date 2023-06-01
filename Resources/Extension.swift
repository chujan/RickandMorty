//
//  Extension.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 17/03/2023.
//

import UIKit
extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice {
    static let isiphone = UIDevice.current.userInterfaceIdiom == .phone
}
