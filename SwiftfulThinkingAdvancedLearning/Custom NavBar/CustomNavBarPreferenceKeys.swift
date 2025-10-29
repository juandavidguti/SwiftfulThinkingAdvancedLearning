//
//  CustomNavBarPreferenceKeys.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import Foundation
import SwiftUI

//@State private var showBackButton: Bool = true
//@State private var title: String = "Title" // ""
//@State private var subtitle: String? = "subtitle" // nil


struct CustomNavBarTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {
    static var defaultValue: String? = nil
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

struct CustomNavBackButtonHiddenPreferenceKey: PreferenceKey {
    static var defaultValue: Bool = false
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View {
    
    func customNavigationTitle(_ title: String) -> some View {
        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
            
    }
    func customNavigationSubtitle(_ subtitle: String?) -> some View {
        preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
            
    }
    func customNavigationBackButtonHidden(_ hidden: Bool) -> some View {
        preference(key: CustomNavBackButtonHiddenPreferenceKey.self, value: hidden)
            
    }
    func customNavBarItems(title: String = "", subtitle: String? = nil, backButtonHideen: Bool = false) -> some View {
        self
            .customNavigationTitle(title)
            .customNavigationSubtitle(subtitle)
            .customNavigationBackButtonHidden(backButtonHideen)
    }
    
//    .navigationTitle("Title2")
//    .navigationBarBackButtonHidden(true)

}
