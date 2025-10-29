//
//  CustomNavLink.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI

struct CustomNavLink<Label:View, Destination:View> : View {
    
    let label: Label
    let destination: Destination
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.label = label()
        self.destination = destination
    }
    
    
    var body: some View {
        NavigationLink {
            CustomNavBarContainerView {
                destination
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
        } label: {
            label
        }

    }
}
#Preview {
    CustomNavView {
        CustomNavLink(destination: Text("Text")) {
            Text("Hello")
        }
    }
    

}
