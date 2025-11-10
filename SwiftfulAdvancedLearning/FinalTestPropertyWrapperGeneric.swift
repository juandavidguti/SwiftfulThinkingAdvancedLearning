import Foundation

/*
 Paso 1

 Definir qué hace exactamente ConfigStore

 Idea mental:
     •    Necesito un tipo genérico que represente una configuración
     •    Tiene un valor por defecto
     •    Tiene un valor actual
     •    Quiero saber si se ha modificado
     •    Quiero poder actualizarlo y resetearlo
 */

// Modelo genérico de configuración
fileprivate struct ConfigStore<Value: Equatable> {
    
    let defaultValue: Value
    private(set) var currentValue: Value
    
    var isModified: Bool {
        defaultValue != currentValue
    }
    
    mutating func update(to newValue: Value) {
        currentValue = newValue
    }
    
    mutating func reset() {
        currentValue = defaultValue
    }
}

// Property wrapper que usa ConfigStore por dentro
@propertyWrapper
fileprivate struct ConfigValue<Value: Equatable> {
    
    private let key: String
    private var store: ConfigStore<Value>
    
    var wrappedValue: Value {
        get { store.currentValue }
        set { store.update(to: newValue) }
    }
    
    // Exponemos la configuración completa
    var projectedValue: ConfigStore<Value> {
        get { store }
        set { store = newValue }
    }
    
    init(wrappedValue: Value, _ key: String) {
        self.key = key
        self.store = ConfigStore(
            defaultValue: wrappedValue,
            currentValue: wrappedValue
        )
    }
}

// Ejemplo de uso
fileprivate struct ModelExample {
    @ConfigValue("membership_status") var isPremium: Bool = true
    @ConfigValue("pin_count")          var pinCount: Int = 10
    @ConfigValue("lucky_numbers")      var luckyNumbers: [Double] = [1.5, 2.4]
    @ConfigValue("username")           var username: String = "juandavidguti"
    
    // Uso real del projected value dentro del mismo tipo
    mutating func resetAll() {
        
        $isPremium.reset()
        $pinCount.reset()
        $luckyNumbers.reset()
        $username.reset()
    }
    
    func debugPrint() {
        print("isPremium: \(isPremium), modified: \($isPremium.isModified)")
        print("pinCount: \(pinCount), modified: \($pinCount.isModified)")
        print("luckyNumbers: \(luckyNumbers), modified: \($luckyNumbers.isModified)")
        print("username: \(username), modified: \($username.isModified)")
    }
}

fileprivate struct Test1 {
    mutating func run() {
        var profile = ModelExample()
        
        print("Estado inicial")
        profile.debugPrint()
        
        profile.isPremium = false
        profile.pinCount = 25
        profile.username = "juan"
        
        print("\nDespues de cambios")
        profile.debugPrint()
        
        profile.resetAll()
        
        print("\nDespues de resetAll")
        profile.debugPrint()
    }
}
