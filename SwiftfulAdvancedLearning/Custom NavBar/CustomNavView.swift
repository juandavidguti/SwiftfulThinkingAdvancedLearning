//
//  CustomNavView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI

struct CustomNavView<T: View>: View {
    
    let content: T
    
    init(@ViewBuilder _ content: () -> T) {
        self.content = content()
    }
    
    
    var body: some View {
        NavigationStack {
            CustomNavBarContainerView {
                content
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    CustomNavView {
        ZStack {
            Color.red
            Text("Hi")
        }
    }
}


// Drag back gesture in Navigation to the left
extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
