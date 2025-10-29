//
//  PreferenceKeyBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import SwiftUI

struct PreferenceKeyBootcamp: View {
    
    @State private var text: String = "Hello world"
    
    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen(text: text)
                    .navigationTitle("Navigation Title")
            }
            .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
               self.text = value
            }
            
        }
    }
    
}

extension View {
    func customTitle(_ text: String) -> some View {
        preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

#Preview {
    PreferenceKeyBootcamp()
}

struct SecondaryScreen: View {
    
    let text: String
    @State private var newValue: String = "first value"
    
    var body: some View {
        Text(text)
            .onAppear{
                getDataFromDatabase()
            }
            .customTitle(newValue)
    }
    
    func getDataFromDatabase() {
        // download
        Task {
            try await Task.sleep(for: .seconds(2))
            self.newValue = "NEW VALUE FROM DATABASE"
        }
    }
}

struct CustomTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
