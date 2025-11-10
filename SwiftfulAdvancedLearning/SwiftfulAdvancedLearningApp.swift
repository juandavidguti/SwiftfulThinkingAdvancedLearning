//
//  SwiftfulAdvancedLearningApp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 23/10/25.
//

import SwiftUI

@main
struct SwiftfulAdvancedLearningApp: App {
    
    let currentUserIsSIgnedIn: Bool
    
    init() {
        
        // for testing in Schemes. USEFUL FOR TIMEZONE, COUNTRIES, DEBUGGING. ARGUMENTS ARE VERY USEFUL FOR TESTING!!
        
//        let userIsSignedIn: Bool = CommandLine.arguments.contains("-UITest_startSignedIn") ? true : false
        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignedIn") ? true : false
        
        // Scheme is exclusive for the app, not testing.
        
//        let value = ProcessInfo.processInfo.environment["-UITest_startSignIn2"]
//        let userIsSignedIn: Bool = value == "true" ? true : false
        self.currentUserIsSIgnedIn = userIsSignedIn
    }
    
    var body: some Scene {
        WindowGroup {
            PropertyWrapperBootcamp()
//            UITestingBootcampView(currentUserIsSIgnedIn: currentUserIsSIgnedIn)
        }
    }
}
