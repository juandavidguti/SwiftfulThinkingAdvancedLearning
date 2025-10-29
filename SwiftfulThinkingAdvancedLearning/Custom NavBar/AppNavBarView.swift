//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red.ignoresSafeArea()
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .foregroundStyle(Color.blue)
                }

            }
            .navigationTitle("Navigation Title")
        }
    }
}

#Preview {
    AppNavBarView()
}
