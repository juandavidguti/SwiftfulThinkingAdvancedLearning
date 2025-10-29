//
//  ScrollViewOffsetPreferenceKeyBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}


extension View {
    func onScrollViewOffsetChange(action: @escaping (_ offset: CGFloat) -> Void )-> some View {
        self
            .background(
                GeometryReader { geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { value in
                action(value)
            })
    }
}

struct ScrollViewOffsetPreferenceKeyBootcamp: View {
    
    let title: String = "Move title here"
    @State private var scrollViewOffset: CGFloat = 0
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                titleLayer
                    .opacity(Double(scrollViewOffset) / 78) // scroll reader
                    .onScrollViewOffsetChange { offset in
                        self.scrollViewOffset = offset
                    }
                    
                contentLayer
            }
            .padding()
            
        }
        .overlay(content: {
            Text("\(scrollViewOffset)")
        })
        
        .overlay(alignment: .top, content: {navBarLayer
            .opacity(scrollViewOffset < 20 ? 1 : 0)
            })

        .scrollIndicators(.hidden)
        
    }
}

extension ScrollViewOffsetPreferenceKeyBootcamp {
    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    private var contentLayer: some View {
        ForEach(0..<30) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.3))
                .frame(width: 300, height: 200)
        }
    }
    private var navBarLayer: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.blue)
    }
}

#Preview {
    ScrollViewOffsetPreferenceKeyBootcamp()
}
