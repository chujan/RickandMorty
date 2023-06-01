//
//  RMSettingOption.swift
//  RickandMorty
//
//  Created by Jennifer Chukwuemeka on 22/05/2023.
//

import UIKit

enum RMSettingOption: CaseIterable {
    case rateApp
    case contactUs
    case privacy
    case terms
    case apiReference
    case viewSeries
    case viewCode
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://iosacademy.io")
        case .privacy:
            return URL(string: "https://iosacademy.io/privacy")
        case .terms:
            return URL(string: "https://iosacademy.io/terms")
        case .apiReference:
           return URL(string: "https://rickandmortyapi.com/documentation/#get-a-single-episode")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UfTWvdl4Ya_2veOB6TH16FXuv4y")
        case .viewCode:
            return URL(string: "https://github.com/AfrazCode/RickAndMortyiOSApp")
        }
        
        
    }
    
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .privacy:
            return "Privacy Policy"
        case .terms:
            return " Terms of Service"
        case .apiReference:
           return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
        
    }
    
    var iconContainerColor: UIColor {
        switch self {
            
        case .rateApp:
            return .systemRed
        case .contactUs:
            return .systemBlue
        case .privacy:
            return.systemBrown
        case .terms:
            return .systemTeal
        case .apiReference:
            return .systemPink
        case .viewSeries:
            return.systemPurple
        case .viewCode:
            return.systemOrange
        }
    }
    var iconImage: UIImage? {
        switch self {
            
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .privacy:
            return UIImage(systemName: "lock")
        case .terms:
            return UIImage(systemName: "doc")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
}
