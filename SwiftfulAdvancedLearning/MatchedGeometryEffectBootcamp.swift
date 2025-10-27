//
//  MatchedGeometryEffectBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 23/10/25.
//

import SwiftUI

struct MatchedGeometryEffectBootcamp: View {
    
    @State private var isClicked: Bool = false
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            if !isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .matchedGeometryEffect(id: "Rectangle", in: namespace)
                    .frame(width: 100, height: 100)
//                .offset(y: isClicked ? Screen.height * 0.92 : 0)
            }
            Spacer()
            if isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .matchedGeometryEffect(id: "Rectangle", in: namespace)
                    .frame(width: 300, height: 200)
            }
        }
        .background(Color.green)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .onTapGesture {
            withAnimation(.easeOut) {
                isClicked.toggle()
            }
        }
    }
}

#Preview {
    MatchedGeometryEffectExample2()
}

struct MatchedGeometryEffectExample2: View {
    
    let categories: [String] = ["house.fill", "bubble.left.and.text.bubble.right.fill", "bell.fill", "ellipsis"]
    @State private var selected: String = "house.fill"
    @Namespace private var namespace2
    
    var body: some View {
        TabView {
            Tab("Home", systemImage: categories[0]) {
                MatchedGeometryEffectBootcamp()
            }
            Tab("DMs", systemImage: categories[1]) {
                AnyTransitionBootcamp()
            }
            
            Tab("Activity", systemImage: categories[2]) {
                MatchedGeometryEffectExample3()
            }
            Tab("More", systemImage: categories[3]) {
                ButtonStyleBootcamp()
            }
        }
        .tint(.yellow)
    }
    
}

struct MatchedGeometryEffectExample3: View {
    
    let categories: [String] = ["World", "Home", "Social", "Settings"]
    @State private var selection: String = ""
    @Namespace private var namespace
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(categories, id: \.self) { category in
                VStack(spacing: 6) {
                    Text(category)
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            selection = category
                        }
                    if selection == category {
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 55, height: 10)
                            .foregroundStyle(.pink)
                            .matchedGeometryEffect(id: "selector", in: namespace)
                    }
                }
                .animation(.linear, value: selection)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
