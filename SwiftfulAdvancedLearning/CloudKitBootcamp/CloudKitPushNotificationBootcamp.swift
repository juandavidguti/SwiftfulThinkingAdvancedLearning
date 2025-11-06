//
//  CloudKitPushNotificationBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 5/11/25.
//

import SwiftUI
import CloudKit

// protocol
// generics
// futures

@Observable class CloudKitPushNotificationBootcampViewModel {
    
    func requestNotificationPermission() {
        
        CloudKitUtility.requestNotifications { confirmation in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                print(confirmation)
            }
        }
    }
    
    func subscribeToNotifications() {
        
        CloudKitUtility
            .subscribe(
                recordType: "Fruits",
                subscriptionID: "fruit_added_2_database",
                options: .firesOnRecordCreation,
                notificationTitle: "Your making progress!!!",
                notificationBody: "Let's keep up! This can be real. the limit is the sky! ",
                notificationSound: "default"
            ) { confirmation in
            print("Subscription is successful: \(confirmation)")
        }
        
    }
    func unsubscribeToNotifications() {
        
        CloudKitUtility.unsubscribe(subscriptionID: "fruit_added_2_database") { confirmation in
            print("Unsubscription is successful: \(confirmation)")
        }
    }
    
}

struct CloudKitPushNotificationBootcamp: View {
    
    @State private var vm = CloudKitPushNotificationBootcampViewModel()
    
    var body: some View {
        VStack {
            Button("Requeest notification permission") {
                vm.requestNotificationPermission()
            }
            
            Button("Subscribe to notifications") {
                vm.subscribeToNotifications()
            }
            
            Button("Unsubscribe to notifications") {
                vm.unsubscribeToNotifications()
            }
        }
    }
}

#Preview {
    CloudKitPushNotificationBootcamp()
}
