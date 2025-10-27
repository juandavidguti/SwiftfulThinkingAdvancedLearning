//
//  ButtonStyleBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 23/10/25.
//

import SwiftUI

struct ButtonPressableStyle: ButtonStyle {
    
    let scaledAmount: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1)
            .brightness(configuration.isPressed ? 0.05 : 0)
            .opacity(configuration.isPressed ? 0.8 : 1)
//            .foregroundStyle((configuration.role == .destructive) ? Color.red : Color.white)
    }
}

extension View {
    func withPressableStyle(scaledAmount: CGFloat = 0.9) -> some View {
        buttonStyle(ButtonPressableStyle(scaledAmount: scaledAmount))
    }
}

struct ButtonStyleBootcamp: View {
    var body: some View {
        ZStack {
//            Image(systemName: "heart.fill")
//                .resizable()
            Button(role: .confirm) {
                
            } label: {
                Text("Click Me")
                    .font(.headline)
                    .withDefaultButtonFormatting(backgroundColor: .green)
            }
            .withPressableStyle(scaledAmount: 1.1)
//            .buttonStyle(.automatic)
            .padding(40)
        }

    }
}

#Preview {

        ButtonStyleBootcamp()

}
