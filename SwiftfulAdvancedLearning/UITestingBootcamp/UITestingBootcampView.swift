//
//  UITestingBootcampView.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 2/11/25.
//

import SwiftUI

@Observable class UITestingBootcampViewModel {
    let placeholderText: String = "Add name here..."
    var textFieldText: String = ""
    var currentUserIsSIgnedIn: Bool
    
    init(currentUserIsSIgnedIn: Bool) {
        self.currentUserIsSIgnedIn = currentUserIsSIgnedIn
    }
    
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else {return}
        currentUserIsSIgnedIn = true
    }
    
    
    
}

struct UITestingBootcampView: View {
    
    @State private var vm: UITestingBootcampViewModel
    
    init(currentUserIsSIgnedIn: Bool){
        _vm = State(wrappedValue: UITestingBootcampViewModel(currentUserIsSIgnedIn: currentUserIsSIgnedIn))
    }
    
    var body: some View {
        
        ZStack {
            LinearGradient(colors: [.blue, .black], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
            
            ZStack {
                if vm.currentUserIsSIgnedIn {
                    SignInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                }
                if !vm.currentUserIsSIgnedIn {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
        
    }
}

extension UITestingBootcampView {
    private var signUpLayer: some View {
        VStack {
            TextField(vm.placeholderText, text: $vm.textFieldText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .accessibilityIdentifier("SignUpTextField") // This is useful for UITesting.
            Button {
                withAnimation(.spring()) { vm.signUpButtonPressed() }
            } label: {
                Text("Sign up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .accessibilityIdentifier("SignUpButton") // This is useful for UITesting.
            }

        }
        .padding()
    }
    
    
}

struct SignInHomeView: View {
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show welcome alert!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        .accessibilityIdentifier("ShowAlertButton")
                }
                .alert(isPresented: $showAlert) {
                    return Alert(title: Text("Welcome to the app!"))
                }
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("NavigationLinkForDestination")
            }
            .navigationTitle("Welcome")
            .padding()
        }
        
    }
}

#Preview {
    UITestingBootcampView(currentUserIsSIgnedIn: true)
}
