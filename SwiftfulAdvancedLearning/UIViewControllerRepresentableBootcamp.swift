//
//  UIViewControllerRepresentableBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by JUAN OLARTE on 10/29/25.
//

import SwiftUI

struct UIViewControllerRepresentableBootcamp: View {
    
    @State private var showScreen: Bool = false
    @State private var showPopover: Bool = false
    @State private var image: UIImage? = nil
    
//    let detents: Set<PresentationDetent> = [.medium, .large]
    
    var body: some View {
        VStack {
            Text("Hi")
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            Button {
                showScreen.toggle()
            } label: {
                Text("Click here")
            }
            .sheet(isPresented: $showScreen) {
                UIImagePickerControllerRepresentable(showScreen: $showScreen, image: $image)
//                BasicUIViewControllerRepresentable(labelText: "New Text here")
            }
        }
    }
}

#Preview {
    UIViewControllerRepresentableBootcamp()
}

struct UIImagePickerControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var showScreen: Bool
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        return vc
    }
    
    // from SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    // from UIkit to SwiftUI
    func makeCoordinator() -> Coordinator {
     return Coordinator(image: $image, showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        
        @Binding var image: UIImage?
        @Binding var showScreen: Bool


        init(image: Binding<UIImage?>, showScreen: Binding<Bool>) {
            self._image = image
            self._showScreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let newImage = info[.originalImage] as? UIImage else {return}
            image = newImage
            showScreen = false
        }
        
    }
}

struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    
    let labelText: String
    
    // the make function is like the init
    func makeUIViewController(context: Context) -> some UIViewController {
       
        let vc = MyFirstViewController()
        
        vc.labelText = labelText
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

class MyFirstViewController: UIViewController {
    
    var labelText: String = "Starting value"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text = labelText
        label.textColor = UIColor.white
        
        view.addSubview(label)
        label.frame = view.frame
        
    }
    
    
}
