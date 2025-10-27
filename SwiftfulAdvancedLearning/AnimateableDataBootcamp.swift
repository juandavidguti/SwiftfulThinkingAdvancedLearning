//
//  AnimateableDataBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 26/10/25.
//

import SwiftUI

struct AnimateableDataBootcamp: View {
    
    @State private var text: String = ""
    @State private var animate: Bool = false          // waves
    @State private var isRunning: Bool = false        // start/stop with one tap
    @State private var mouthAngle: CGFloat = 0        // Pacman angle (0..40)
    
    var body: some View {
        ZStack {
            VStack {
                Text(text)
                    .font(.headline)
                    .foregroundStyle(.red)
                Text("Bite!!")
                    .font(.title)
                    .foregroundStyle(.black)
                    .padding()
                    .glassEffect(.regular.tint(.teal).interactive())
                    .onTapGesture {
                        if isRunning {
                            // Stop and close mouth
                            isRunning = false
                            mouthAngle = 0
                        } else {
                            // Start and set target angle; the repeating animation will bounce between 0 and 40
                            isRunning = true
                            mouthAngle = 40
                        }
                    }
                Pacman(offsetAmount: mouthAngle)
                
                    .fill(LinearGradient(colors: [Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1))], startPoint: .top, endPoint: .bottom))
//                    .background(Color.green)
                    .frame(width: 300, height: 300)
                    .onTapGesture {
                        text = "pacman hit!!"
                    }
                    .animation(isRunning ? .easeInOut(duration: 0.2).repeatForever(autoreverses: true) : .default, value: mouthAngle)
                
            }
            
            .zIndex(isRunning ? 2 : 0)
            
            // Back wave
            Group {
                WaterWave(
                    amplitude: 0.10,
                    base: animate ? 0.65 : 0.35,   // sube y baja
                    phase: animate ? 4 * 2 : 0,  // avanza horizontalmente
                    frequency: 1
                        
                )
                .foregroundStyle(.blue.opacity(0.6))
                .onTapGesture {
                text = "background wave hit!!"
            }
                
                // Front wave (intercalada), 180° desfasada
                WaterWave(
                    amplitude: 0.12,
                    base: animate ? 0.65 : 0.35,
                    phase: (animate ? 3 * 2 : 0) + .pi, // desfase
                    frequency: 1
                        
                )
                .foregroundStyle(.blue.opacity(0.9))
                .onTapGesture {
                text = "front wave hit!!"
            }
            }
           
        }
            
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
//                // hace que el nivel base suba y baje
                animate.toggle()
            }
        }
        .onDisappear {
            // Any unrelated cleanup here (none for pacman)
        }
    }
}

#Preview {
    AnimateableDataBootcamp()
}


struct RectangleWithSingleCornerAnimation: Shape {
    
    var cornerRadius: CGFloat
    
    var animatableData: CGFloat {
        get { cornerRadius }
        set { cornerRadius = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
            
            path
                .addArc(
                    center: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
                    radius: cornerRadius,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 360),
                    clockwise: false
                )
            
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}

struct Pacman: Shape {
    
    var offsetAmount: CGFloat
    
    var animatableData: CGFloat {
        get {
            offsetAmount
        }
        set {
            offsetAmount = newValue
        }
    }
    
    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.height / 2, startAngle: Angle(degrees: offsetAmount), endAngle: Angle.degrees(360-offsetAmount), clockwise: false)
        }
    }
}


struct WaterWave: Shape {
    /// Amplitude relative to the rect height (0...1)
    var amplitude: CGFloat
    /// Base level as a fraction of the rect height (0...1 from top)
    var base: CGFloat
    /// Horizontal phase (radians). Animate this for left-right motion.
    var phase: CGFloat
    /// Number of full waves across the width
    var frequency: CGFloat = 2

    // Animate amplitude, base and phase together
    var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
        get { AnimatablePair(amplitude, AnimatablePair(base, phase)) }
        set {
            amplitude = newValue.first
            base = newValue.second.first
            phase = newValue.second.second
        }
    }

    nonisolated func path(in rect: CGRect) -> Path {
        let A = rect.height * amplitude
        let baseY = rect.height * base
        let twoPiF = .pi * 2 * frequency
        let step = max(1.0, rect.width / 120) // ~120 samples across

        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: baseY + A * sin(phase)))

        var x = rect.minX
        while x <= rect.maxX {
            let t = (x - rect.minX) / rect.width
            let y = baseY + A * sin(twoPiF * t + phase)
            path.addLine(to: CGPoint(x: x, y: y))
            x += step
        }

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
