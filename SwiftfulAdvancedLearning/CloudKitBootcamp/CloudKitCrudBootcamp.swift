//
//  CloudKitCrudBootcamp.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 5/11/25.
//

import SwiftUI
import CloudKit
import Combine

struct FruitModel: CloudKitableProtocol {
    let name: String
    let imageURL: URL?
    let record: CKRecord
    let count: Int
    
    init?(record: CKRecord) {
        guard let name = record["name"] as? String else {return nil}
        self.name = name
        let imageAsset = record["image"] as? CKAsset
        self.imageURL = imageAsset?.fileURL
        self.record = record
        let count = record["count"] as? Int
        self.count = count ?? 0
    }
    
    init?(name: String, imageURL: URL?, count: Int?) {
        let record = CKRecord(recordType: "Fruits")
        record["name"] = name
        if let url = imageURL {
            let asset = CKAsset(fileURL: url)
            record["image"] = asset
        }
        if let count = count {
            record["count"] = count
        }
        self.init(record: record)
        
    }
    
    func update(newName: String) -> FruitModel? {
        let record = record
        record["name"] = newName
        return FruitModel(record: record)
    }
    
}

@Observable class CloudKitCrudBootcampViewModel {
    
    var text: String = ""
    var fruits: [FruitModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init () {
        fetchItems()
    }
    
    func addButtonPressed() {
        guard !text.isEmpty else {return}
        addItem(name: text)
    }
    
    private func addItem(name: String) {
        guard
            let image = UIImage(named: "landscape"),
        let url = FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent("landscape.jpg"),
              let data = image.jpegData(compressionQuality: 1.0) else {return}
        
        do {
            try data.write(to: url)
            guard let newFruit = FruitModel(name: name, imageURL: url, count: 5) else {return}
            CloudKitUtility.add(item: newFruit) { result in
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.fetchItems()
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    func fetchItems() {
        
        let predicate = NSPredicate(value: true) // filter
        let recordType = "Fruits"
        //        let predicate = NSPredicate(format: "name = %@", argumentArray: ["Coconut"])
        //        queryOperation.resultsLimit = 2 // max is 100
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                self?.fruits = returnedItems
            }
            .store(in: &cancellables)
    }
    
    
    func addOperations(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateItem(fruit: FruitModel) {
        guard let newFruit = fruit.update(newName: "NEW NAMEEE!!!") else {return}
        CloudKitUtility.update(item: newFruit) { [weak self] result in
            print("Update completed!")
            self?.fetchItems()
        }
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        CloudKitUtility.delete(item: fruit)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.fetchItems()
            } receiveValue: { [weak self] confirmation in
                print("Delete is: \(confirmation)")
                self?.fruits.remove(at: index)
            }
            .store(in: &cancellables)
    }
}


struct CloudKitCrudBootcamp: View {
    
    @State private var viewModel = CloudKitCrudBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                header
                textField
                button
                
                List {
                    ForEach(viewModel.fruits, id: \.self) { fruit in
                        HStack {
                            Text(fruit.name)
                            
                            if let url = fruit.imageURL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            }
                            
                        }
                        .onTapGesture {
                            viewModel.updateItem(fruit: fruit)
                        }
                    }
                    .onDelete(perform: viewModel.deleteItem)
                }
                .listStyle(.plain)
            }
            .toolbarVisibility(.hidden, for: .navigationBar)
            .padding()
        }
    }
}

#Preview {
    CloudKitCrudBootcamp()
}

extension CloudKitCrudBootcamp {
    private var header: some View {
        Text("CloudKit CRUD ☁️☁️☁️")
            .font(.headline)
            .underline()
    }
    
    private var textField: some View {
        TextField("Add text here.. ", text: $viewModel.text)
            .frame(height: 55)
            .background(Color.gray.opacity(0.4))
            .cornerRadius(10)
    }
    
    private var button: some View {
        Button {
            viewModel.addButtonPressed()
        } label: {
            Text("Add")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.pink)
                .cornerRadius(10)
        }
    }
}
