//
//  KeyPathsBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 7/11/25.
//

import SwiftUI

struct MyDataModel: Identifiable {
    let id = UUID().uuidString
    let title: String
    let count: Int
    let date: Date
}

struct MovieTitle {
    let primary: String
    let secondary: String
}

extension Array {
    
    // this is going to mutate the array in place for the variable, not return a new array like in the case below where we used let.
    mutating func sortByKeyPath<T : Comparable>(_ keyPath: KeyPath<Element, T>, ascending: Bool = true){
        self.sort { item1, item2 in
            
            let value1 = item1[keyPath: keyPath]
            let value2 = item2[keyPath: keyPath]
            return ascending ? (value1 < value2) : (value1 > value2)
        }
    }
    func sortedByKeyPath<T : Comparable>(_ keyPath: KeyPath<Element, T>, ascending: Bool = true) -> [Element] {
        self.sorted { item1, item2 in
            
            let value1 = item1[keyPath: keyPath]
            let value2 = item2[keyPath: keyPath]
            
            
            return ascending ? (value1 < value2) : (value1 > value2)
        }
    }
}


struct KeypathsBootcamp: View {
    
    @State private var screenTitle: String = ""
    @State private var dataArray: [MyDataModel] = []
    
    // Keypaths defined by Apple
//    @Environment(\.dismiss) var dismiss
//    @Environment(\.isPresented) var isPresented
//    
    // Keypaths that we can define
    @AppStorage("user_count") var userCount: Int = 0
    
    var body: some View {
        List {
            ForEach(dataArray) { item in
                VStack(alignment: .leading) {
                    Text(item.id)
                    Text(item.title)
                    Text("\(item.count)")
                    Text(item.date.description)
                }
            }
        }
        Text(screenTitle)
            .onAppear {
                
                var array = [
                    MyDataModel(title: "One", count: 1, date: .distantPast),
                    MyDataModel(title: "Two", count: 2, date: .now),
                    MyDataModel(title: "Three", count: 3, date: .distantFuture)
                ]
                
//                let newArray = array.sorted { item1, item2 in
//                    return item1.count < item2.count
//                }
//                let newArray = array.sorted { item1, item2 in
//                    return item1[keyPath: \.count] < item2[keyPath: \.count]
//                }
                
//                let newArray = array.sortedByKeyPath(\.count, ascending: false)
//                dataArray = newArray
                
                array.sortByKeyPath(\.count, ascending: true)
                dataArray = array
//                let title = item.title
//                let title2 = item[keyPath: \.title]
//                screenTitle = title2
            }
    }
}

#Preview {
    KeypathsBootcamp()
}
