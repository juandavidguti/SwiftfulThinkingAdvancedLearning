//
//  PropertyWrapper2Bootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 10/11/25.
//

import SwiftUI


@propertyWrapper
struct Capitalized: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue.capitalized
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
}


@propertyWrapper
struct Uppercased: DynamicProperty {
    @State private var value: String
    
    var wrappedValue: String {
        get {
            value
        }
        nonmutating set {
            value = newValue.uppercased()
        }
    }
    
    init(wrappedValue: String) {
        self.value = wrappedValue.uppercased()
    }
}

@propertyWrapper
struct FileManagerCodable2<T: Codable>: DynamicProperty {
    @State private var value: T?
    let key: String
    
    var wrappedValue: T? {
        get {
            value
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    
    var projectedValue: Binding<T?> {
        Binding(
            get: {wrappedValue},
            set: {wrappedValue = $0})
    }
    
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(initialValue: object)
            print("Success")
        } catch {
            _value = State(initialValue: nil)
            print("ERROR READ \(error)")
        }
    }
    
    init(_ key: KeyPath<FileManagerValues, FileManagerKeypath<T>>) {
        
        let keypath = FileManagerValues.shared[keyPath: key]
        let key = keypath.key
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(initialValue: object)
            print("Success")
        } catch {
            _value = State(initialValue: nil)
            print("ERROR READ \(error)")
        }
    }
    
    private func save(newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key: key))
            value = newValue
            print("Success")
        } catch  {
            print("ERROR READ \(error)")
        }
    }
}

struct User: Codable{
    let name: String
    let age: Int
    let isPremium: Bool
}

// for keypath
struct FileManagerValues {
    static let shared = FileManagerValues()
    private init(){}
    
//    let userProfile = "userprofile"
    let userProfile = FileManagerKeypath(key: "user_profile", type: User.self)

}

struct FileManagerKeypath<T:Codable> {
    let key: String
    let type: T.Type
}

import Combine
@propertyWrapper
struct FileManagerCodableStreamableProperty<T: Codable>: DynamicProperty {
    @State private var value: T?
    let key: String
    private let publisher: CurrentValueSubject<T?, Never>
    
    var wrappedValue: T? {
        get {
            value
        }
        nonmutating set {
            save(newValue: newValue)
        }
    }
    var projectedValue: CustomProjectedValue<T> {
        CustomProjectedValue(
            binding: Binding(
            get: {wrappedValue},
            set: {wrappedValue = $0}),
            publisher: publisher)
    }
        
    init(_ key: String) {
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(initialValue: object)
            publisher = CurrentValueSubject(object)
            print("Success")
        } catch {
            _value = State(initialValue: nil)
            publisher = CurrentValueSubject(nil)
            print("ERROR READ \(error)")
        }
    }
    
    init(_ key: KeyPath<FileManagerValues, FileManagerKeypath<T>>) {
        
        let keypath = FileManagerValues.shared[keyPath: key]
        let key = keypath.key
        self.key = key
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let object = try JSONDecoder().decode(T.self, from: data)
            _value = State(initialValue: object)
            publisher = CurrentValueSubject(object)
            print("Success")
        } catch {
            _value = State(initialValue: nil)
            publisher = CurrentValueSubject(nil)
            print("ERROR READ \(error)")
        }
    }
    
    private func save(newValue: T?) {
        do {
            let data = try JSONEncoder().encode(newValue)
            try data.write(to: FileManager.documentsPath(key: key))
            value = newValue
            publisher.send(newValue)
            print("Success")
        } catch  {
            print("ERROR READ \(error)")
        }
    }
}

struct CustomProjectedValue<T:Codable> {
    var binding: Binding<T?>
    let publisher: CurrentValueSubject<T?, Never>
    
    var stream:  AsyncPublisher<CurrentValueSubject<T?, Never>> {
         publisher.values
    }
}

struct PropertyWrapper2Bootcamp: View {
    
    @Uppercased private var title: String = "hello world"
//    @FileManagerCodable2("user_profile") var userProfile: User?
//    @FileManagerCodable2(\.userProfile) var userProfile: User?
//    @FileManagerCodable2(\.userProfile) private var userProfile
    @FileManagerCodableStreamableProperty(\.userProfile) private var userProfile
    
    var body: some View {
        VStack {
            
            Button(title) {
                title = "new title".capitalized
            }
            SomeBindingView(userProfile: $userProfile.binding)
            Button(userProfile?.name ?? "no value") {
                userProfile = User(name: "Juan", age: 1111, isPremium: true)
            }
        }
        .onReceive($userProfile.publisher, perform: { newValue in // combine
            print("RECEIVED NEW VALUE OF: \(newValue)")
        })
        //
        .task { // Swift Concurrency
            for await newValue in $userProfile.stream {
                print("STREAM NEW VALUE OF: \(newValue)")
            }
        }
        .onAppear {
            print(NSHomeDirectory())
        }
    }
}

struct SomeBindingView: View {
    
    @Binding var userProfile: User?
    
    var body: some View {
        Button(userProfile?.name ?? "no value") {
            userProfile = User(name: "JuanDavid", age: 232, isPremium: false)
        }
    }
}

#Preview {
    PropertyWrapper2Bootcamp()
}
