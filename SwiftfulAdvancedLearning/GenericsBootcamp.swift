//
//  GenericsBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 26/10/25.
//

import SwiftUI

struct StringModel {
    let info: String?
    // update a new version of the model
    func removeInfo() -> StringModel {
         StringModel(info: nil)
    }
}
struct BoolModel {
    let info: Bool?
    // update a new version of the model
    func removeInfo() -> BoolModel {
         BoolModel(info: nil)
    }
}

struct GenericModel<T> { // generics, any letter works but normally we use T of custom Type.
    let info: T?
    
    func removeInfo() -> GenericModel {
        GenericModel(info: nil)
    }
}

@Observable
final class GenericsViewModel {
    
    var stringModel = StringModel(info: "Hello world")
    var boolModel = BoolModel(info: false)
    var genericStringModel = GenericModel(info: "Hello world")
    var genericBoolModel = GenericModel(info: true)
    
    init() {
        
    }
    
    // we can always use this because the array accepts Generic types.
    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
}


struct GenericView<T : View> : View { // this type conforms to view
    let content: T
    let title: String
    var body: some View {
        VStack {
            Text(title)
            content
        }
    }
}

struct GenericsBootcamp: View {
    
    @State var vm = GenericsViewModel()
    
    var body: some View {
        
        VStack {
            GenericView(content: Text("custom content"), title: "New view")
//            GenericView(title: "new View")
            Text(vm.stringModel.info ?? "no data")
                
            Text(vm.boolModel.info?.description ?? "no data")
            Text(vm.genericStringModel.info ?? "no data")
            Text(vm.genericBoolModel.info?.description ?? "no data")
                
        }
        .onTapGesture {
            vm.removeData()
        }
    
        
//        VStack {
//            ForEach(vm.dataArray, id: \.self) { item in
//                Text(item)
//                    .onTapGesture {
//                        vm.removeDataArray()
//                    }
//            }
//        }
    }
}

#Preview {
    GenericsBootcamp()
}
