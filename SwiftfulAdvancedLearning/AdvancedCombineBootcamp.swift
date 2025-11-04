//
//  AdvancedCombineBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 4/11/25.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
//    @Published var basicPublisher: String = "First value"
//    let currentValuePublisher = CurrentValueSubject<String, Error>("First value")
    
    let passThroughPublisher = PassthroughSubject<Int, Error>() // more memory efficient than currentValueSubject
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int,Error>()
    
    init() {
        publishFakeData()
    }
    
    func publishFakeData() {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10] //Array(1..<11)
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x)){
                self.passThroughPublisher.send(items[x])
                
                if (x > 4 && x < 8) { // the X refers to the index, not the value.
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999)
                } else {
                    self.boolPublisher.send(false)
                }
                
                if x == items.indices.last {
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            self.passThroughPublisher.send(1)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.passThroughPublisher.send(2)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.passThroughPublisher.send(3)
//        }
    }
    
}

@Observable class AdvancedCombineBootcampViewModel {
    
    var data: [String] = []
    var dataBools: [Bool] = []
    var error: String = ""
    let dataService = AdvancedCombineDataService()
    var cancellables = Set<AnyCancellable>()
    let multiCastPublisher = PassthroughSubject<Int, Error>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
//        dataService.passThroughPublisher
        
            // Sequence Operations
            /*
    //            .first()
    //            .first(where: {$0 > 4})
    //            .tryFirst(where: { int in
    //                if int == 3 {
    //                    throw URLError(.badServerResponse)
    //                }
    //                return int > 1
    //            })
    //            .last()
    //            .last(where: {$0 < 4})
    //            .tryLast(where: { int in
    //                if int == 13 {
    //                    throw URLError(.badServerResponse)
    //                }
    //                return int > 1
    //            })
    //            .dropFirst()
    //            .dropFirst(3)
    //            .drop(while: {$0 < 5})
    //            .tryDrop(while: { int in
    //                if int == 15 {
    //                    throw URLError(.badServerResponse)
    //                }
    //                return int < 6
    //            })
    //            .prefix(4)
    //            .prefix(while: {$0 < 5})
    //            .tryPrefix(while: )
    //            .output(at: 5)
    //            .output(in: 2..<4)
            */
        
            // Mathematic Operations
            /*
    //            .max()
    //            .max(by: { Int1, int2 in
    //                return Int1 < int2
    //            })
    //            .tryMax(by: )
    //            .min()
    //            .min(by: )
    //            .tryMin(by: )
            */
        
            // Filter / Reducting Operations
            /*
                //.map({ String($0)})
    //            .tryMap({ int in
    //                if int == 5 {
    //                    throw URLError(.badServerResponse)
    //                }
    //                return String(int)
    //            })
    //            .compactMap({ int in
    //                if int == 5 {
    //                    return nil
    //                }
    //                return "\(int)" // String(int)
    //            })
    //            .tryCompactMap()
    //            .filter({($0 > 3) && ($0 < 7)})
    //            .tryFilter()
    //            .removeDuplicates()
    //            .removeDuplicates(by: { Int1, int2 in
    //                return Int1 == int2
    //            })
    //            .tryRemoveDuplicates(by: )
    //            .replaceNil(with: 5)
    //            .replaceEmpty(with: [])
    //            .replaceError(with: "Default Value")
    //            .scan(0, { existingValue, newValue in
    //                return existingValue + newValue
    //            })
    //            .scan(0, {$0 + $1})
    //            .scan(0, +) // shortest form
    //            .tryScan(, )
    //            .reduce(0, { existingValue, newValue in
    //                return existingValue + newValue
    //            })
    //            .reduce(0, +) // Aggregated sum.
    //            .collect() // publish at once, instead of one by one.
    //            .collect(3)
    //            .allSatisfy({$0 < 15})
    //            .tryAllSatisfy()
            */
        
            // Timing Operations
            /*
    //            .debounce(for: 1, scheduler: DispatchQueue.main) // wait for time before sending to a thread (publish)
    //            .delay(for: 2, scheduler: DispatchQueue.main)
    //            .measureInterval(using: DispatchQueue.main)
    //            .map({ stride in
    //                return "\(stride.timeInterval)"
    //            })
    //            .throttle(for: 5, scheduler: DispatchQueue.main, latest: true)
    //            .retry(2)
    //            .timeout(0.75, scheduler: DispatchQueue.main) // useful for 5-10 seconds if an API does not respond
            
            */
        
            // Multiple Publishers / Subscribers
            /*
//            .combineLatest(dataService.boolPublisher, dataService.intPublisher)
//            .compactMap({ (int, bool) in
//                if bool {
//                    return String(int)
//                } else {
//                    return nil
//                }
//            })
//            .compactMap({ (int, bool, int2) in
//                if bool {
//                    return String(int)
//                }
//                return "n/a"
//            })
//            .merge(with: dataService.intPublisher)
//            .zip(dataService.boolPublisher, dataService.intPublisher)
//            .map({ tuple in
//                return String(tuple.0) + tuple.1.description + String(tuple.2)
//            })
//            .tryMap({ int in
//                
//                if int == 5 {
//                    throw URLError(.badServerResponse)
//                }
//                return int
//            })
//            .catch({ error in
//                return self.dataService.intPublisher
//            })
        
        */
        
        let sharedPublisher = dataService.passThroughPublisher
//            .dropFirst(3)
            .share()
//            .multicast {
//                PassthroughSubject<Int,Error>()
//            }
            .multicast(subject: multiCastPublisher)
        sharedPublisher
            .map({ String($0)})
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = "Error: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] returnedValue in
                self?.data.append(returnedValue)
//                self?.data = returnedValue
//                self?.data.append(contentsOf: returnedValue)
            }
            .store(in: &cancellables)
        
        sharedPublisher
            .map({ $0 > 5 ? true : false })
            .sink { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = "Error: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] returnedValue in
                self?.dataBools.append(returnedValue)
            }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            sharedPublisher
                .connect()
                .store(in: &self.cancellables)
        }
    }
}

struct AdvancedCombineBootcamp: View {
    
    @State private var vm = AdvancedCombineBootcampViewModel()
    
    var body: some View {
        ScrollView {
            HStack {
                VStack {
                    ForEach(vm.data, id: \.self) { // item in
                        //                    Text(item)
                        Text($0)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                    if !vm.error.isEmpty {
                        Text(vm.error)
                    }
                }
                VStack {
                    ForEach(vm.dataBools, id: \.self) { // item in
                        //                    Text(item)
                        Text($0.description)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    AdvancedCombineBootcamp()
}
