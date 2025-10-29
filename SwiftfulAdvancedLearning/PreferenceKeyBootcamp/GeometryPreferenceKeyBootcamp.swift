//
//  GeometryPreferenceKeyBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 27/10/25.
//

import SwiftUI

struct GeometryPreferenceKeyBootcamp: View {
    
    @State private var rectSize: CGSize = .zero
    
    var body: some View {
        VStack {

            Text("hello")
                .frame(width: rectSize.width, height: rectSize.height)
                .background(Color.blue)
            Spacer()
            HStack {
                Rectangle()
                GeometryReader { geo in
                    Rectangle()
                    // We get the value of the geo reader from the rectangle and pass that backwards up to the rectSize variable to update the frame size.
                        .updateRectangleGeoSize(geo.size)
                }
                Rectangle()
            }
            .frame(height: 50)
            .background(Color.black.opacity(0.5))
        }
        .onPreferenceChange(RectangleGeometrySizePreferenceKey.self) { value in
            self.rectSize = value
        }
    }
}

extension View {
    func updateRectangleGeoSize(_ size: CGSize) -> some View {
        preference(key: RectangleGeometrySizePreferenceKey.self, value: size)
    }
}

struct RectangleGeometrySizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    GeometryPreferenceKeyBootcamp()
}
