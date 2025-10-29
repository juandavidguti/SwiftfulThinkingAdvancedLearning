//
//  TabBarItem.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import Foundation
import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable {
    case home, favorites, profile
    
    var iconName: String {
        switch self {
            case .home:
                "house"
            case .favorites:
                "heart"
            case .profile:
                "person"
        }
    }
    
    var title: String {
        switch self {
            case .home:
                "home"
            case .favorites:
                "favorites"
            case .profile:
                "profile"
        }
    }
    
    var color: Color {
        switch self {
            case .home:
                Color.red
            case .favorites:
                Color.blue
            case .profile:
                Color.green
        }
    }
}
