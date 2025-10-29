//
//  TabBarItemsPreferenceKey.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItem] = []
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct TabBarItemViewModifier: ViewModifier {
    
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
            modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}

