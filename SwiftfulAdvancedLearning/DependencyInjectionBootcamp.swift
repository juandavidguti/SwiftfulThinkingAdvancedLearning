//
//  DependencyInjectionBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 1/11/25.
//

import SwiftUI
import Combine

// PROBLEMS WITH SINGLETONS
// 1. Singletons are GLOBAL. Anywhere from the app. We don't want global variables in production apps. Can cause multithread crashes.
// 2. Can't customize the init!
// 3. Can't swap out dependencies.
// Dependency injection is the solution!

struct PostsModel: Codable, Identifiable {
    
    let userId: Int
    let id: Int
    let title: String
    let body: String
}


protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostsModel], Error>
    
}

class ProductionDataService: DataServiceProtocol {
  
    
//    static let instance = ProductionDataService() // Singleton initialize a single instance for the class wihtin the class
    
    // SIngle is great for learning but there' a lot of flaws and problems when using it.
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostsModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}



class MockDataService: DataServiceProtocol {
    
    let testData: [PostsModel]
    
    init(data: [PostsModel]?) {
        self.testData = data ?? [
            
            PostsModel(userId: 1, id: 1, title: "one", body: "two"),
            PostsModel(userId: 2, id: 2, title: "two", body: "two")
            
        ]
    }
    
    func getData() -> AnyPublisher<[PostsModel], Error> {
        Just(testData)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
}

// larger apps don't pass the each dependency in every class and struct, they use a class with dependencies and pass that around. like a parent class as below in a quick example:

//class Dependencies {
//    let dataService: DataServiceProtocol
//    
//    init(dataService: DataServiceProtocol) {
//        self.dataService = dataService
//    }
//}
 



@Observable class DependencyInjectionViewModel {
    
    var cancellables = Set<AnyCancellable>()
    
    let dataService: DataServiceProtocol
    
    var dataArray: [PostsModel] = []
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { _ in
                
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellables)
    }
    
}

struct DependencyInjectionBootcamp: View {
    
    init(dataService: DataServiceProtocol) {
        _vm = State(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    @State private var vm: DependencyInjectionViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}

#Preview {
    
//    let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    let dataService = MockDataService(data: [
        PostsModel(userId: 3, id: 3, title: "dasdf", body: "asdfa")
    ])
    
    DependencyInjectionBootcamp(dataService: dataService)
}
