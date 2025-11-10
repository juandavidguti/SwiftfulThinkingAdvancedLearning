//
//  CloudKitUserBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 5/11/25.
//

// Zones are private sections in Database. The container cannot be deleted.
// there are development and production versionso f the container.
// add a capability for cloudkit/icloud.
// the information in records is the icloud account, not the user itself. From the icloud account we can get the name

import SwiftUI
import CloudKit
import Combine

@Observable class CloudKitBootcampViewModel {
    
    var isSignedIn: Bool = false
    var error: String = ""
    var userName: String = ""
    var permissionStatus: Bool = false
    @ObservationIgnored var cancellables = Set<AnyCancellable>()
    
    init() {
        getiCloudStatus()
        requestPermission()
        getCurrentUserName()
    }
    
    private func getiCloudStatus() {
        
        CloudKitUtility.getiCloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        break
                    case.failure(let error):
                        self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSignedIn = success
            }
            .store(in: &cancellables)
    }
    
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCLoudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    func requestPermission() {
        
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }
    
    func getCurrentUserName() {
        CloudKitUtility.discoveryUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.userName = success
            }
            .store(in: &cancellables)

    }
    
}


struct CloudKitUserBootcamp: View {
    
    @State private var vm = CloudKitBootcampViewModel()
    
    var body: some View {
        VStack {
            Text("Is signed In: \(vm.isSignedIn.description)")
            Text(vm.error)
            Text("Name: \(vm.userName)")
            Text(vm.permissionStatus.description)
        }
    }
}

#Preview {
    CloudKitUserBootcamp()
}
