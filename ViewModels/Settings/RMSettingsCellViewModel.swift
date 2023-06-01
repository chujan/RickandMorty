//
//  RMSettingViewModel.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 22/05/2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    var id =  UUID()
    
    public var image: UIImage? {
        return type.iconImage
    }
  public  var title: String {
      return type.displayTitle
       
      
    }
    public let type: RMSettingOption
    public let onTapHandler: (RMSettingOption) -> Void
        
    
    
    init(type: RMSettingOption, onTapHandler: @escaping(RMSettingOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
       
    }
    public var iconContainerColor: UIColor {
        return type.iconContainerColor
        
    }
    
}
