//
//  ProtocolsBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 29/10/25.
//

import SwiftUI

struct defaultColorTheme {
    let primary: Color = .blue
    let secondary: Color = .white
    let terciary: Color = .gray
    
}

struct ProtocolsBootcamp: View {
    
    let colorTheme: defaultColorTheme = defaultColorTheme()
    
    var body: some View {
        ZStack {
            colorTheme.terciary.ignoresSafeArea()
            Text("Protocols are awesome!")
                .font(.headline)
                .foregroundStyle(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
        }
            
    }
}

#Preview {
    ProtocolsBootcamp()
}
