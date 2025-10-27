//
//  AnyTransitionBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 23/10/25.
//

import SwiftUI

enum ScreenOrigin {
    case top, bottom, leading, trailing
    case topLeading, topTrailing, bottomLeading, bottomTrailing
    case center

    func offset(for size: CGSize) -> CGSize {
        switch self {
        case .topLeading:      return CGSize(width: -size.width, height: -size.height)
        case .topTrailing:     return CGSize(width:  size.width, height: -size.height)
        case .bottomLeading:   return CGSize(width: -size.width, height:  size.height)
        case .bottomTrailing:  return CGSize(width:  size.width, height:  size.height)
        case .top:             return CGSize(width: 0,           height: -size.height)
        case .bottom:          return CGSize(width: 0,           height:  size.height)
        case .leading:         return CGSize(width: -size.width, height: 0)
        case .trailing:        return CGSize(width:  size.width, height: 0)
        case .center:          return .zero
        }
    }
}

struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    let origin: ScreenOrigin
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(rotation != 0 ? (origin.offset(for: Screen.size)) : .zero)
    }
}

extension AnyTransition {
    static var rotating: AnyTransition {
        .modifier(
            active: RotateViewModifier(rotation: 1080, origin: .bottomTrailing),
            identity: RotateViewModifier(rotation: 0, origin: .bottomTrailing)
        )
    }
    static func rotating(rotation: Double = 90, from origin: ScreenOrigin = .bottomTrailing) -> AnyTransition {
        .modifier(
            active: RotateViewModifier(rotation: rotation, origin: origin),
            identity: RotateViewModifier(rotation: 0, origin: origin)
        )
    }
    
    static func rotateOn(rotation: Double = 90, from origin: ScreenOrigin = .bottomTrailing, removalEdge: ScreenOrigin = .bottomTrailing) -> AnyTransition {
        .asymmetric(insertion: .rotating(rotation: rotation, from: origin), removal: .rotating(rotation: rotation, from: removalEdge))
    }
}

struct AnyTransitionBootcamp: View {
    
    @State private var showRectangle: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 250, height: 350, alignment: .center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.rotateOn(rotation: 360, from: .topLeading, removalEdge: .topTrailing))
            }
            
            Spacer()
            
            Text("Click Me")
                .withDefaultButtonFormatting()
                .padding(.horizontal, 40)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        showRectangle.toggle()
                    }
                }
        }
    }
}



#Preview {
    AnyTransitionBootcamp()
}
