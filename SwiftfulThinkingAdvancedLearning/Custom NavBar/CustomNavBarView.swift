//
//  CustomNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI

struct CustomNavBarView: View {
    
    @Environment(\.dismiss) var dismiss
    let showBackButton: Bool
   let title: String  // ""
    let subtitle: String? // nil
    
    
    var body: some View {
        HStack {
            if showBackButton {
                backButton
            }
            Spacer()
            titleSection
            Spacer()
            if showBackButton {
                backButton
                    .opacity(0)
            }
        }
        .padding()
        .tint(.white)
        .foregroundStyle(.white)
        .font(.headline)
        .background(Color.blue)
    }
}

#Preview {
    VStack {
        CustomNavBarView(showBackButton: true, title: "Title", subtitle: "subtitle")
        Spacer()
    }
}

extension CustomNavBarView {
    private var backButton: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
    
    private var titleSection: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subtitle = subtitle {
                Text(subtitle)
            }
        }
    }
}
