//
//  AppTabBarView.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import SwiftUI

// we are going to use.
// Generics
// View Builder
// PreferenceKey
// MatchedGeometryEffect

struct AppTabBarView: View {
    
    @State private var selection: String = "home"
    @State private var tabSelection: TabBarItem =         .home

    
    var body: some View {
//        defaultTabView
        CustomTabBarContainerView(selection: $tabSelection) {
            Color.blue
                .tabBarItem(tab: TabBarItem.home, selection: $tabSelection)
            Color.red
                .tabBarItem(tab: TabBarItem.favorites, selection: $tabSelection)
            Color.green
                .tabBarItem(tab: TabBarItem.profile, selection: $tabSelection)
        }
    }
}

#Preview {
    AppTabBarView()
}

extension AppTabBarView {
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            Tab("Home", systemImage: "house.fill", value: "Hello") {
                Color.red
            }
            Tab("Favorites", systemImage: "heart", value: "Heart") {
                Color.blue
            }
            Tab("Profile", systemImage: "person", value: "THis is a test 3") {
                Color.orange
            }
        }
    }
}
