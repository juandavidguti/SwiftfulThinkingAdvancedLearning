//
//  ProtocolsBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 29/10/25.
//

import SwiftUI

struct DefaultColorTheme: ColorThemeProtocol {
    let primary: Color = .blue
    let secondary: Color = .white
    let terciary: Color = .gray
}

struct AlternativeColorTheme: ColorThemeProtocol {
    let primary: Color = .red
    let secondary: Color = .white
    let terciary: Color = .green
}

struct AnotherColorTheme: ColorThemeProtocol {
    var primary: Color = .blue
    var secondary: Color = .red
    var terciary: Color = .purple
}

protocol ColorThemeProtocol {
    var primary: Color { get }
    var secondary: Color { get }
    var terciary: Color { get }
}

protocol ButtonTextProtocol {
    var buttonText: String { get }
}

protocol ButtonPressedProtocol {
    func buttonPressed()
}

protocol ButtonDataSourceProtocol: ButtonTextProtocol, ButtonPressedProtocol {
    
}

class DefaultDataSource: ButtonDataSourceProtocol {
    var buttonText: String = "Protocols are awesome!"
    func buttonPressed() {
        print("Button was pressed!")
    }
}

class AlternativeDataSource: ButtonTextProtocol {
    var buttonText: String = "Protocols are awesome!"

}



struct ProtocolsBootcamp: View {
    
    let colorTheme: ColorThemeProtocol // = DefaultColorTheme() AlternativeColorTheme()
    let dataSource: ButtonDataSourceProtocol
    
    var body: some View {
        ZStack {
            colorTheme.terciary.ignoresSafeArea()
            Text(dataSource.buttonText)
                .font(.headline)
                .foregroundStyle(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
                .onTapGesture {
                    dataSource.buttonPressed()
                }
        }
            
    }
}

#Preview {
    ProtocolsBootcamp(colorTheme: DefaultColorTheme(), dataSource: DefaultDataSource())
}
