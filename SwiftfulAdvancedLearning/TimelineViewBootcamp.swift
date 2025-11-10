//
//  TimelineViewBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 7/11/25.
//

import SwiftUI

// Timeline is better for complex animations, just triggering a boolean to animate a state is good for just 1 animation back and forth.
struct TimelineViewBootcamp: View {
    
    @State private var startTime: Date = .now
    @State private var pauseAnimation: Bool = false
    
    
    var body: some View {
        VStack {
            TimelineView(.animation(minimumInterval: 1, paused: pauseAnimation)) { context in
                Text("\(context.date)")
                Text("\(context.date.timeIntervalSince1970)")
                
                let seconds = context.date.timeIntervalSince(startTime)
//                let seconds = Calendar.current.component(.second, from: context.date)
                Text("\(seconds)")
                
                if context.cadence == .live {
                    Text("Cadence: Live")
                } else if context.cadence == .minutes {
                    Text("Cadence: Minutes")
                } else if context.cadence == .seconds {
                    Text("Cadence: seconds")
                }
                
                Rectangle()
                    .frame(
                        width: seconds < 10 ? 50 : seconds < 30 ? 200 : 400,
                        height: 100
                    )
                    .animation(.bouncy, value: seconds)
            }
            Button(pauseAnimation ? "PLAY" : "PAUSE") {
                pauseAnimation.toggle()
            }
        }
    }
}

#Preview {
    TimelineViewBootcamp()
}
