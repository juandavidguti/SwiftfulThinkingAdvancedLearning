//
//  CustomOperatorBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 11/11/25.
//

import SwiftUI

struct CustomOperatorBootcamp: View {
    
    @State private var value: Double = 0
    
    var body: some View {
        Text("\(value)")
            .onAppear {
//                value = 5 + 5
//                value = 5 / 2
//                value = 5 +/ 1
//                value = 7 ++/ 3
//                value = 3 ^^^ 5
                
                let someValue: Int = 5
//                value = Double(someValue)
                
                value = someValue => Double.self
            }
    }
}

// the operator we're about to use is going to be an operator, not normal text in code
infix operator +/
infix operator ++/
infix operator ^^^
infix operator =>

extension FloatingPoint {
    static func +/ (lhs: Self, rhs: Self) -> Self {
        (lhs + rhs) / 2
    }
    static func ++/ (lhs: Self, rhs: Self) -> Self {
        (lhs + lhs) / rhs
    }
    static func ^^^ (lhs: Self, rhs: Self) -> Self {
        max(lhs, rhs)
    }
}

protocol InitFromBinaryInteger {
    init<Source>(_ value: Source) where Source:BinaryInteger // Double documentation
}

extension Double: InitFromBinaryInteger {
    
}

extension BinaryInteger {
    static func => <T:InitFromBinaryInteger>(value: Self, newType: T.Type) -> T {
        return T(value)
    }
}

#Preview {
    CustomOperatorBootcamp()
}
