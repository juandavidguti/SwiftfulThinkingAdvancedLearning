//
//  ErrorAlertBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 7/11/25.
//

import SwiftUI


// ERROR: Actual error that ruins the application
// ALERT: The UI that displays to the user

protocol AppAlert {
    var title: String {get}
    var subtitle: String? {get}
    var actions: AnyView {get}
}

extension View {
    func showCustomAlert<T : AppAlert>(alert: Binding<T?>) -> some View {
        self
            .alert(alert.wrappedValue?.title ?? "Error", isPresented: Binding(value: alert), actions: {
                alert.wrappedValue?.actions
            }, message: {
                if let subtitle = alert.wrappedValue?.subtitle {
                    Text(subtitle)
                }
            })
    }
}


struct ErrorAlertBootcamp: View {
    
    @State private var alert: MyCustomAlert? = nil
    @State private var countAlert: Int = 0
    
    var body: some View {
        Text("Alert count: \(countAlert)")
        Button("Click me") {
            saveData()
        }
        .showCustomAlert(alert: $alert)
//        .alert(error?.localizedDescription ?? "Error", isPresented: Binding(value: $error)) {
//            Button("OK") {
//                
//            }
//        }
    }
    
    
    
//    enum MyCustomError: Error, LocalizedError {
//        case noInternetConnection, dataNotFound, urlError(error: Error)
//        
//        var errorDescription: String? {
//            switch self {
//                case .noInternetConnection:
//                    return "Please check your internet connection and try again"
//                case .dataNotFound:
//                    return "There was an error loading data. Please try again."
//                    
//                case .urlError(error: let error):
//                    return "Error: \(error.localizedDescription)"
//            }
//        }
//    }
    
    enum MyCustomAlert: Error, LocalizedError, AppAlert {
       
        case noInternetConnection(onOkPressed: () -> Void, onRetryPressed: () -> Void)
        case dataNotFound
        case urlError(error: Error)
        
        var title: String {
            switch self {
                case .noInternetConnection:
                    return "Not internet connection"
                case .dataNotFound:
                    return "No data"
                case .urlError(let error):
                    return "error"
            }
        }
        
        var subtitle: String? {
            switch self {
                case .noInternetConnection:
                    return "Please check your internet connection and try again"
                case .dataNotFound:
                    return "There was an error loading data. Please try again."
                case .urlError(let error):
                    return "error"
            }
        }
        
        // Protocol conform to anyview
        var actions: AnyView {
            AnyView(getButtonsForAlert)
        }
        
        @ViewBuilder
        var getButtonsForAlert: some View {
            switch self {
                case .noInternetConnection(onOkPressed: let onOkPressed, onRetryPressed: let onRetryPressed):
                    Button("Ok") {
                        onOkPressed()
                    }
                    Button("Retry") {
                        onRetryPressed()
                    }
                case .dataNotFound:
                    Button("Retry") {
                        
                    }
                case .urlError(let error):
                    Button("Ok") {
                        
                    }
                default:
                    Button("delete", role: .destructive) {
                        
                    }
            }
        }
        
        var errorDescription: String? {
            switch self {
                case .noInternetConnection:
                    return "Please check your internet connection and try again"
                case .dataNotFound:
                    return nil
                    
                case .urlError(error: let error):
                    return "Error: \(error.localizedDescription)"
            }
        }
        
        
    }
    
    private func saveData() {
        let isSuccessful: Bool = false
        if isSuccessful {
            // do something
        } else {
            // error
//            let myError: Error = URLError(.badURL)
//            let myError: Error = MyCustomAlert.urlError(error: URLError(.badURL))
//            errorTitle = "An error occured!"
            
            alert = .noInternetConnection(onOkPressed: {
                countAlert += 1
            }, onRetryPressed: {
                if countAlert <= 0 {
                    countAlert = 0
                } else {
                    countAlert -= 1
                }
            })
        }
    }
}

#Preview {
    ErrorAlertBootcamp()
}
