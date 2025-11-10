//
//  CustomBindingBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 7/11/25.
//

import SwiftUI

extension Binding where Value == Bool {
    
    init<T>(value: Binding<T?>) {
        self.init {
            value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}

struct CustomBindingBootcamp: View {
    
    @State private var firstTitle: String = "Start"
    
    @State private var errorTitle: String? = nil
//    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            Text(firstTitle)
            
            ChildView1(bindingTitle: $firstTitle)
            ChildView2(noBindingtitle: firstTitle) { newTitle in
                firstTitle = newTitle
            }
            ChildView3(title: $firstTitle)
            
            // A binding can be constructed on the fly. We just need the get and the set. $ sign does this for us.
            ChildView3(title: Binding(get: {
                return firstTitle
            }, set: { newValue in
                firstTitle = newValue
            }))
            
//            Text(showError.description)
            
            Button("Click me") {
                errorTitle = "NEW ERROR"
//                showError.toggle()
            }
        }
        .alert(errorTitle ?? "Error", isPresented: Binding(value: $errorTitle)) {
            Button("Ok") {
                
            }
        }
//        .alert(errorTitle ?? "Error", isPresented: $showError) {
//            Button("Ok") {
//                
//            }
//        }
//        .alert(errorTitle ?? "Error", isPresented: Binding(get: {
//            errorTitle != nil
//        }, set: { newValue in
//            if !newValue {
//                errorTitle = nil
//            }
//        })) {
//            Button("Ok") {
//                
//            }
//        }
    }
}

struct ChildView1: View {
    
    @Binding var bindingTitle: String
    
    var body: some View {
        Text(bindingTitle)
            .onAppear {
//                bindingTitle = "New Title"
            }
    }
}

struct ChildView2: View {
    
    // without Binding doing the same thing as ChildView1
    let noBindingtitle: String
    let setTitle: (String) -> ()
    
    var body: some View {
        Text(noBindingtitle)
            .onAppear {
                setTitle("New title 2")
            }
    }
}

struct ChildView3: View {
    
    let title: Binding<String>
    
    var body: some View {
        Text(title.wrappedValue)
            .onAppear {
                title.wrappedValue = "NEW TITLE 3"
            }
    }
}

#Preview {
    CustomBindingBootcamp()
}
