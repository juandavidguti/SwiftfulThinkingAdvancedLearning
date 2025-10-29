//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                CustomNavLink(destination:
                                Text("I did it!")
                    .customNavigationTitle("Second Screen")
                    .customNavigationSubtitle("Subtitle should be showing")
                    .customNavigationBackButtonHidden(false)
                ) {
                    Text("Yes!!")
                }
            }
            .customNavBarItems(title: "New Title", subtitle: "Hello", backButtonHideen: true)
        }
    }
}

#Preview {
    AppNavBarView()
}

extension AppNavBarView {
    private var defaultNavBarView: some View{
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink {
                    Text("Destination")
                        .navigationTitle("Title2")
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Text("Navigate")
                        .foregroundStyle(Color.blue)
                }
            }
            .navigationTitle("Navigation Title")
        }
    }
}
