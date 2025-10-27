//
//  CustomShapesBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 24/10/25.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            
            // the axis increase from top leading (left corner) to bottom trailing (right corner).
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY)) // No need to add the final line as the system fills the shape but just for debugging is better.
        }
    }
}


struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let horizontalOffset: CGFloat = rect.width * 0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}

struct Hexagon: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let offset: CGFloat = rect.width * 0.25
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            // left side
            path.addLine(to: CGPoint(x: rect.minX + offset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY - offset))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + offset))
            path.addLine(to: CGPoint(x: rect.midX - offset, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            // right side
            path.addLine(to: CGPoint(x: rect.midX + offset, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + offset))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY - offset))
            path.addLine(to: CGPoint(x: rect.midX + offset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            
        }
    }
}

struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let offset: CGFloat = rect.width * 0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + offset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.minY))
            
        }
    }
}

struct CustomShapesBootcamp: View {
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    Trapezoid()
                        .frame(width: 300,height: 100)
                    Image("landscape")
                            .resizable()
                            .frame(width: 300,height: 300)
                            .clipShape(Hexagon())
                    Hexagon()
                        .frame(width: 300,height: 300)
                    Diamond()
                        .frame(width: 300,height: 300)
                    Triangle()
                        .frame(width: 300,height: 300)
                }
                
            }
                

               
//                    .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10]))
//                    .foregroundStyle(.blue)
//                    .fill(Color.red)
//                    .frame(width: 300,height: 300)
//                    .clipShape(Triangle()
//                        .rotation(Angle(degrees: 180))
//                    )
                    
            }
        }
    }

#Preview {
    CustomShapesBootcamp()
}
