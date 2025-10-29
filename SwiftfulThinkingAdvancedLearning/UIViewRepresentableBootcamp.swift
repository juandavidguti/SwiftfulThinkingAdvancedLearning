//
//  UIViewRepresentableBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI


// used to convert a UIView from UIKit to SwiftUI
struct UIViewRepresentableBootcamp: View {
    
    @State private var text: String = ""
    
    
    var body: some View {
        VStack {
            Text(text)
            HStack {
                Text("SwiftUI")
                TextField("New Placeholder Swift", text: $text)
                    .frame(height: 55)
                    .background(Color.gray)
            }
            HStack {
                Text("UIKit")
                UITextFieldUIViewRepresentable(text: $text)
                    .updatePlaceholder("new placeholder UIKit")
                    .frame(height: 55)
                    .background(Color.gray)
            }
        }
    }
}

struct UITextFieldUIViewRepresentable: UIViewRepresentable {
    
    // every uiviewrepresentable must conform to the protocols make and update
    @Binding var text: String
    var placeholder: String
    let placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Default Placeholder...", placeholderColor: UIColor = .red){
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
        
    }
    
    // from SwiftUI to UIKIt
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    
    // customize UITextField && UIKitView
    private func getTextField() -> UITextField {
        
        let placeholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor : placeholderColor
                
            ]
        )
        let textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = placeholder
//        textField.delegate
        return textField
    }
    
    func updatePlaceholder(_ text: String) -> UITextFieldUIViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    // From UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

#Preview {
    UIViewRepresentableBootcamp()
}

struct BasicUIViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
