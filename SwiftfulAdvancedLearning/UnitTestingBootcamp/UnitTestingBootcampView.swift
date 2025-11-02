//
//  UnitTestingBootcampView.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 1/11/25.
//

/*
 2 types of tests.
 1. Unit Tests
 
 - Test the business logic in your app, even edge cases (downloading data from the internet fails for example).
 
 2. UI Tests
 
 - Test the UI of your App
 
 
 */


import SwiftUI

struct UnitTestingBootcampView: View {
    
    @StateObject private var vm: UnitTestingBootcampViewModel
    
    // adding "_vm" refers that we access the wrapped value.
    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingBootcampViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }
}

#Preview {
    UnitTestingBootcampView(isPremium: true)
}
