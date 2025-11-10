//
//  PropertyWrapperBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 7/11/25.
//

import SwiftUI

extension FileManager {
    static func documentsPath(key: String) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appending(path: key)
    }
}

@propertyWrapper
struct FileManagerProperty: DynamicProperty {
    
    
    @State private var title: String // unica fuente de verdad
    let key: String
    
    // a computed variable is interpreted as a get function, we set the value that we want it to get.
    
    var wrappedValue: String {     // la interfaz para acceder a esta fuente de verdad

        get { // leer
            title
        }
        nonmutating set { // escribir
            saveFileManager(newValue: newValue)
        }
    }
    
    var projectedValue: Binding<String> {
        Binding {
            wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }

    }
    
    init(wrappedValue: String, _ key: String) {
        self.key = key
        // load from file manager
        do {
            title = try String(contentsOf: FileManager.documentsPath(key: key), encoding: .utf8)
            print("SUCCESS READ")
        }
        catch {
            title = wrappedValue
            print("ERROR READ \(error)")
        }
    }

    
    func saveFileManager(newValue: String) {
        
        do {
            // When atomically is set to true, it means that the data will be written to a temporary file first.
            // When atomically is set to false, the data is written directly to the specified file path.
            try newValue.write(to: FileManager.documentsPath(key: key), atomically: false, encoding: .utf8)
            title = newValue
//            print(NSHomeDirectory()) // tip for directory of the simulator.
            print("SUCCESS")
        } catch let error {
            print("Error")
        }
    }
    
}

struct PropertyWrapperBootcamp: View {
    
//    @State private var title: String = "Starting title"
//    var fileManagerProperty = FileManagerProperty()
    @FileManagerProperty("custom_title_1") private var title: String = "Start text 1" // lee y escribe esa fuente de verdad
    @FileManagerProperty("custom_title_2") private var title2: String = "Start text 2"
    @FileManagerProperty("custom_title_3") private var title3: String = "Start text 3"
    
//    @FileManagerProperty private var title: String
//    @FileManagerProperty private var title2: String
//    @AppStorage("title_key") private var title3: String = ""
    @State private var subtitle: String = "Subtitle"
    
//    init() {
        // This is initializing the property wrapper with a default starting value.
//        _subtitle = State(wrappedValue: "Starting value")
//    }
    
    
    var body: some View {
        VStack(spacing: 40) {
            Text(title).font(.largeTitle)
            Text(title2).font(.largeTitle)
            Text(title3).font(.largeTitle)
            Text(subtitle).font(.largeTitle)
            PropertyWrapperChildView(subtitle: $title) // aca le decimos al binding que lea y escriba en ese mismo wrapped value.
            
            Button("click me 1") {
                title = "title1"
            }
            Button("click me 2") {
                title = "title2"
                title2 = "Some random title"
            }
        }

    }
    
}

struct PropertyWrapperChildView: View {
    
    @Binding var subtitle: String // esta propiedad tambien lee y escribe ese mismo wrapped value
    
    var body: some View {
        Button {
            subtitle = "Another subtitle!!!"
        } label: {
            Text(subtitle).font(.largeTitle)
        }
    }
}

#Preview {
    PropertyWrapperBootcamp()
}

@propertyWrapper
struct PropertyWrapperRange {
    
    private var maxRange: Int = Int.random(in: 0...100)
    
    var wrappedValue: Int {
        get {
            // recibe numero de la vista
            maxRange
        }
        nonmutating set {
            // llama a funcion limitRange
        }
    }
    var projectedValue: Binding<Int> {
        Binding {
            // binding del wrapped value
            wrappedValue
        } set: { newValue in
            // ejecuta el set del wrappedvalue dandole un nuevo valor.
            wrappedValue = newValue
        }
    }
    
    func limitRange (newValue: Int){
        // limita rango que acerca a 0 si es negativo e iguala a 100 si es mayor que 100.
    }
}

protocol ProfileModelProtocol: Identifiable, Codable {
    var id: String {get}
    var name: String {get}
    var isPremium: Bool {get}
    var memories: Int {get}
}

struct DataProfileModel: ProfileModelProtocol {
    let id: String
    let name: String
    let isPremium: Bool
    let memories: Int
}

// Codable Property Example CHATGPT
@propertyWrapper
struct FileManagerCodableProperty<T: ProfileModelProtocol>: DynamicProperty {
    
    @State private var profileData: T
    private let key: String
    
    var wrappedValue: T {
        get {
            profileData
        }
        nonmutating set {
            saveToDisk(newValue)
        }
    }
    
    
    init(wrappedValue: T, _ key: String) {
        self.key = key
        
        do {
            let url = FileManager.documentsPath(key: key)
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            _profileData = State(initialValue: decoded)
            print("Success Read Codable")
        } catch {
            _profileData = State(initialValue: wrappedValue)
            print("Error Read Codable", error.localizedDescription)
        }
    }
    
    
    private func saveToDisk(_ newValue: T) {
        do {
            let data = try JSONEncoder().encode(newValue)
            let url = FileManager.documentsPath(key: key)
            try data.write(to: url, options: .atomic)
            profileData = newValue
            print("SUCCESS SAVE CODABLE")
        } catch let error {
            print("Error saving in Device. Error: \(error.localizedDescription)")
        }
    }
}






