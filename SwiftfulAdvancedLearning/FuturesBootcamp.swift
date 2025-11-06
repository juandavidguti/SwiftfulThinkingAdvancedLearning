//
//  FuturesBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 4/11/25.
//

import SwiftUI
import Combine

// download with Combine
// download with @escaping closures


@Observable class FuturesBootcampViewModel {
    
    var title: String = "Starting Title"
    let url = URL(string: "https://www.google.com")!
    var cancellables = Set<AnyCancellable>()
    
    init() {
        download()
    }
    
    func download() {
        //        getCombinePublisher()
        getFuturePublisher()
        //            .sink { _ in
        //
        //            } receiveValue: { [weak self] returnedValue in
        //                self?.title = returnedValue
        //            }
        //            .store(in: &cancellables)
        //    }
//        getEscapingClosure { [weak self] returnedValue, error in
//            self?.title = returnedValue
//        }
        
    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "new Value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(completionHandler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completionHandler("New Value 2", nil)
        }
        .resume()
    }
    
    func getFuturePublisher() -> Future<String, Error> {
        Future { promise in
            self.getEscapingClosure { returnedValue, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(returnedValue))
                }
            }
        }
    }
    
    func doSomething(completion: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completion("New String")
        }
    }
    func doSomethingInTheFuture() -> Future<String, Never> {
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
        }
    }
}

struct FuturesBootcamp: View {
    
    @State private var vm = FuturesBootcampViewModel()
    
    var body: some View {
        Text(vm.title)
    }
}

#Preview {
    FuturesBootcamp()
}
