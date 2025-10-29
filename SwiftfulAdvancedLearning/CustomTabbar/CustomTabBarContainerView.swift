//
//  CustomTabBarContainerView.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = []
    
    let content: Content
    
    init(
    selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection // when we use the underscore we refer to the wrapped value of the Binding
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content.ignoresSafeArea()
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
            self.tabs = value
        }
    }
}

#Preview {
    
    let tabs: [TabBarItem] = [
        .home, .favorites, .profile
    ]
    
    CustomTabBarContainerView(selection: .constant(tabs.first!)) {
        Color.red
    }
}
