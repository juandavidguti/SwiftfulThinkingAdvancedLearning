//
//  GenericsyPropertyWrapperPractice.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 10/11/25.
//

import Foundation
import Playgrounds
import SwiftUI

// quiero poder modificar configuraciones existentes a travees de una logica generica que acepte diferentes tipos de entrada. Editar configuraciones del perfil del usuario en una sola logica sin repetir funciones para actualizar por ejemplo edad, nombre, estado, foto. todo se puede hacer si encapsulo estas propiedades en una wrapper de propoiedades.
// Un property wrapper sirve para empaquetar una lógica repetitiva asociada a una propiedad.
// Un genérico en Swift sirve para escribir una vez un comportamiento que funciona con cualquier tipo, sin duplicar código.
// Estás practicando cómo encapsular comportamiento genérico dentro de un tipo reusable.

fileprivate struct ConfigProfile<T: Equatable> : Equatable {
    let defaultValue: T
    var currentValue: T
    var isModified: Bool {
        defaultValue != currentValue
    }
    
    mutating func reset() {
        currentValue = defaultValue
    }
    mutating func update(to newValue: T) {
        currentValue = newValue
    }
}

@propertyWrapper
fileprivate struct ConfigProfilePropertyWrapper<T: Equatable> {
    
    private(set) var myConfiguration: ConfigProfile<T>
    
    var wrappedValue: T {
        get { myConfiguration.currentValue }
        set { myConfiguration.update(to: newValue)}
    }
    
    init(wrappedValue: T) {
        myConfiguration = ConfigProfile(defaultValue: wrappedValue, currentValue: wrappedValue)
    }
    
    var projectedValue: ConfigProfile<T> {
        get { myConfiguration }
        set { myConfiguration = newValue }
    }
}

fileprivate struct TestModel {
    @ConfigProfilePropertyWrapper var name: String = "Juan"
    @ConfigProfilePropertyWrapper var likeEggs: Bool = true
    @ConfigProfilePropertyWrapper var christmasTrees: Int = 56
    @ConfigProfilePropertyWrapper var elementsBought: [Double] = [1,2,3,6,4,5]
    @ConfigProfilePropertyWrapper var netflixMovies: [String] = ["Vikings", "PeakyBlinder", "BD"]
        
        mutating func resetAll(){
            $name.reset()
            $likeEggs.reset()
            $christmasTrees.reset()
            $elementsBought.reset()
            $netflixMovies.reset()
    }
}

//#Playground {
//    var person = TestModel()
//    print(person.name)
//    person.name = "David"
//    print(person.name)
//    print(person.likeEggs)
//    person.likeEggs = false
//    print(person.$likeEggs.isModified.description)
//}


struct FeatureFlagStore<T> {
    var valueOfFlag: T
    
    mutating func change(to newFlagValue: T) {
        valueOfFlag = newFlagValue
    }
}
@propertyWrapper
struct FeatureFlagValue<T> {
    
    private(set) var featureFlag: FeatureFlagStore<T>
    
    var wrappedValue: T {
        get {
            featureFlag.valueOfFlag
        }
        set{
            featureFlag.change(to: newValue)
        }
    }
    init(wrappedValue: T) {
        featureFlag = FeatureFlagStore(valueOfFlag: wrappedValue)
    }
    var projectedValue: FeatureFlagStore<T> {
        get {
            featureFlag
        } set {
            featureFlag = newValue
        }
    }
}

struct FeatureFlagTestModel {
    @FeatureFlagValue var newHomoeEnabled: Bool = false
    @FeatureFlagValue var recommendedLimit: Int = 10
}

//#Playground {
//    var feature = FeatureFlagTestModel()
//    print(feature.recommendedLimit)
//    feature.newHomoeEnabled = true
//    print(feature.$newHomoeEnabled.valueOfFlag.description)
//}
//

@propertyWrapper
struct myCustomProperty: DynamicProperty {
    @State private var title: String
    
    var wrappedValue: String {
        get { title }
        nonmutating set {
            title = newValue
        }
    }
    
    var projectedValue: Binding<String> {
        Binding {
            title
        } set: { newValue in
            title = newValue
        }
    }
    
    init(wrappedValue: String) {
        title = wrappedValue
    }
    
//    func updateTitle(newTitle: String) {
//        title = newTitle
//    }
}

struct myTestView: View {
    
    @State var active: Bool
    @State var showAlert: Bool
    @State var deleteAlert: Bool
    @myCustomProperty var name: String
    @myCustomProperty var title2: String
    
    var body: some View {
        
        List {
            Section {
                HStack {
                    Text("Your Name: ")
                        .fontWeight(.medium)
                    Text(name)
                        .font(.title2)
                }
                Button(active ? "Erase Data" : "Create New Data") {
                    if active {
                        // Mostrar alerta de confirmación
                        deleteAlert = true
                    } else {
                        // Acción directa
                        withAnimation(.bouncy) {
                            active.toggle()
                            title2 = "New Data"
                            name = "Juan Of Future"
                        }
                    }
                }
                
                Button("Recover Old Data") {
                    showAlert.toggle()
                }
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .frame(width: 200, height: 200)
                            .foregroundStyle(active ? .green : .red)
                            .shadow(radius: 10)
                            .scaleEffect(active ? 1.1 : 0.5)
                            .padding()
                        Text(active ? "100%" : "0%").font(active ? .title : .callout)
                    }
                    Spacer()
                    
                }
                if active {
                    HStack(spacing:2) {
                        Text("Current Data loaded: ")
                            .foregroundStyle(.black)
                            .fontWeight(.thin)
                        Text(title2)
                            .font(.largeTitle)
                            .fontWeight(.black)
                    }
                }
            }
            header: {
                Text("These are your saved data preferences.")
            }
        }
        
        .sheet(isPresented: $showAlert) {
            ChildTestView(showAlert: $showAlert, active: $active, title2: $title2, name: $name)
                .presentationDetents([.medium])
        }
        .alert("Are you sure you want to erase your data?",
               isPresented: $deleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Erase", role: .destructive) {
                withAnimation(.bouncy) {
                    active = false
                    title2 = ""
                    name = ""
                }
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

struct ChildTestView: View {
    
    @Binding var showAlert: Bool
    @Binding var active: Bool
    @Binding var title2: String
    @Binding var name: String
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .orange, .blue], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea().opacity(0.2)
//                .glassEffect()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            VStack (spacing:20) {
                Text("Tap to restore your old data, drag down to dismiss")
                    .multilineTextAlignment(.center)
                Button("RECOVER") {
                    withAnimation(.bouncy) {
                        showAlert.toggle()
                        active = true
                        title2 = "Old Data"
                        name = "Juan del Pasado"
                    }
                }
            }
            .padding(.horizontal, 20)
        }
            }
}

#Preview {
    myTestView(active: false, showAlert: false, deleteAlert: false, name: "", title2: "")
}

