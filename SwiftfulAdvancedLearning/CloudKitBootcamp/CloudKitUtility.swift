//
//  CloudKitUtility.swift
//  SwiftfulAdvancedLearning
//
//  Created by Juan David Gutierrez Olarte on 6/11/25.
//

import Foundation
import CloudKit
import Combine
import UIKit

protocol CloudKitableProtocol: Hashable {
    init?(record: CKRecord)
    var record: CKRecord {get}
}

struct CloudKitFruitModelNames {
    // add here data to match the database
}

class CloudKitUtility {
    
    enum CloudKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCLoudAccountNotDetermined
        case iCloudAccountRestricted
        case iCloudAccountUnknown
        case iCloudApplicationPermissionNotGranted
        case iCloudErrorCouldNotFetchUserRecordId
        case iCloudCouldNotDiscoverUser
    }
    

}


// MARK: USER FUNCTIONS:
extension CloudKitUtility {
    
    // statics to be able to access to them from whenever or wherever in our code. No need to instance the class.
    static private func getiCloudStatus(completion: @escaping (Result<Bool,Error>) -> ()) {
        CKContainer.default().accountStatus { returnedStatus, returnedError in
            switch returnedStatus {
                case .couldNotDetermine:
                    completion(.failure(CloudKitError.iCLoudAccountNotDetermined))
                case .available:
                    completion(.success(true))
                case .restricted:
                    completion(.failure(CloudKitError.iCloudAccountRestricted))
                case .noAccount:
                    completion(.failure(CloudKitError.iCloudAccountNotFound))
                default:
                    completion(.failure(CloudKitError.iCloudAccountUnknown))
            }
        }
    }
    
    static func getiCloudStatus() -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.getiCloudStatus { result in
                promise(result)
            }
        }
    }
    

    static private func requestApplicationPermission(completion: @escaping (Result<Bool,Error>) -> ()) {
        CKContainer.default().requestApplicationPermission([.userDiscoverability]) {  returnedStatus, returnedError in
                if returnedStatus == .granted{
                    completion(.success(true))
                    
                } else {
                    completion(.failure(CloudKitError.iCloudApplicationPermissionNotGranted))
                }
            
        }
    }
    
    static func requestApplicationPermission() -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.requestApplicationPermission { result in
                promise(result)
            }
        }
    }
    
    static private func fetchUserRecordID(completion: @escaping (Result<CKRecord.ID,Error>) -> ()){
        CKContainer.default().fetchUserRecordID { returnedId, returnedError in
            if let id = returnedId {
                completion(.success(id))
            } else if let error = returnedError {
                completion(.failure(error))
            }
            else {
                completion(.failure(CloudKitError.iCloudErrorCouldNotFetchUserRecordId))
            }
        }
    }
    
    static private func discoveryUserIdentity(id: CKRecord.ID, completion: @escaping (Result<String,Error>) -> ()) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { returnedIdentity, returnedError in
                if let name = returnedIdentity?.nameComponents?.givenName {
                    completion(.success(name))
                } else {
                    completion(.failure(CloudKitError.iCloudCouldNotDiscoverUser))
                }
//                returnedIdentity?.lookupInfo?.emailAddress
            
        }
    }
    
    static private func discoveryUserIdentity(completion: @escaping (Result<String,Error>) -> ()) {
        fetchUserRecordID { fetchCompletion in
            switch fetchCompletion {
                case .success(let recordId):
                    CloudKitUtility.discoveryUserIdentity(id: recordId,completion: completion)
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    static func discoveryUserIdentity() -> Future<String, Error> {
        Future { promise in
            CloudKitUtility.discoveryUserIdentity { result in
                promise(result)
            }
        }
    }
    
}


// MARK: CRUD FUNCTIONS:

extension CloudKitUtility {
    
    static func fetch<T : CloudKitableProtocol>(predicate: NSPredicate,
                      recordType: CKRecord.RecordType,
                      sortDescriptions: [NSSortDescriptor]? = nil,
                      resultsLimit: Int? = nil) -> Future<[T], Error> {
        Future { promise in
            CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptions, resultsLimit: resultsLimit) { (items : [T]) in
                promise(.success(items))
            }
        }
    }
    
    static private func fetch<T:CloudKitableProtocol>(predicate: NSPredicate,
                      recordType: CKRecord.RecordType,
                      sortDescriptions: [NSSortDescriptor]? = nil,
                      resultsLimit: Int? = nil,
                      completion: @escaping (_ items: [T]) -> ()) {
        
        // create operation
        let operation = createOperation(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptions, resultsLimit: resultsLimit)

        // Get items in query
        var returnedItems: [T] = []
        addRecordMatchedBlock(operation: operation) { item in
            returnedItems.append(item)
        }
        
        // Query completion
        addQueryResultBlock(operation: operation) { finished in
            completion(returnedItems)
        }
        
        
        // Execute operation
        add(operation: operation)
    }
    
    static private func createOperation(
        predicate: NSPredicate,
        recordType: CKRecord.RecordType,
        sortDescriptions: [NSSortDescriptor]? = nil,
        resultsLimit: Int? = nil
    ) -> CKQueryOperation {
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = sortDescriptions
        let queryOperation = CKQueryOperation(query: query)
        if let limit = resultsLimit {
            queryOperation.resultsLimit = 2 // max is 100
        }
        return queryOperation
    }
    
    static private func addRecordMatchedBlock<T:CloudKitableProtocol>(operation: CKQueryOperation, completion: @escaping (_ item: T) -> ()) {
        operation.recordMatchedBlock = { returnedRecordID, returnedResult in
            switch returnedResult {
                case .success(let record):
                    guard let item = T(record: record) else {return}
                    completion(item)
                case .failure:
                    break
            }
        }
    }
    
    static private func addQueryResultBlock(operation: CKQueryOperation, completion: @escaping (_ finished: Bool) -> ()) {
        operation.queryResultBlock = { result in
            completion(true)
        }
    }

    
    
    static private func add(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    static func add<T:CloudKitableProtocol>(item: T, completion: @escaping(Result<Bool, Error>) -> () ) {
        
        let record = item.record
        saveItem(record: record, completion: completion)
    }
    
    static func update<T:CloudKitableProtocol>(item: T, completion: @escaping(Result<Bool, Error>) -> () ) {
        add(item: item, completion: completion)
    }

    
    static func saveItem(record: CKRecord, completion: @escaping(Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.save(record) { record, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static func delete<T:CloudKitableProtocol>(item: T) -> Future<Bool, Error> {
        Future { promise in
            CloudKitUtility.delete(item: item, completion: promise)
        }
    }
    
    static private func delete<T:CloudKitableProtocol>(item: T, completion: @escaping(Result<Bool, Error>) -> ()) {
        delete(record: item.record, completion: completion)
    }
    
    static private func delete(record: CKRecord, completion: @escaping(Result<Bool, Error>) -> ()) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) {  returnedRecordId, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    // let's challenge myself and create references from this file to the push notification ones.
    
    
}

// MARK: PUSH NOTIFICATIONS:

extension CloudKitUtility {
    
    static func subscribe(recordType: CKRecord.RecordType, subscriptionID: CKSubscription.ID, options: CKQuerySubscription.Options, notificationTitle: String, notificationBody: String, notificationSound: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        subscribeRaw(recordType: recordType, predicate: NSPredicate(value: true), subscriptionID: subscriptionID, options: options, notificationTitle: notificationTitle, notificationBody: notificationBody, notificationSound: notificationSound, completion: completion)
    }
    
    static private func subscribeRaw(recordType: CKRecord.RecordType, predicate: NSPredicate, subscriptionID: CKSubscription.ID, options: CKQuerySubscription.Options, notificationTitle: String, notificationBody: String, notificationSound: String, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subscriptionID, options: options)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = notificationTitle
        notification.alertBody = notificationBody
        notification.soundName = notificationSound
        
        subscription.notificationInfo = notification
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static func unsubscribe(subscriptionID: CKSubscription.ID, completion: @escaping(Result<Bool, Error>)->()){
        unsubscribeRaw(subscriptionID: subscriptionID, completion: completion)
    }
    
    static private func unsubscribeRaw(subscriptionID: CKSubscription.ID, completion: @escaping (Result<Bool, Error>) -> () ) {
        
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: subscriptionID) { returnedId, returnedError in
            if let error = returnedError {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    static private func requestNotificationsRaw(options: UNAuthorizationOptions, completion: @escaping( Result<Bool,Error>) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, returnedError in
            if let error = returnedError {
                completion(.failure(error))
                print("Notification permissions failure:\(String(describing: completion))")
            } else {
                completion(.success(true))
                print("Notification permissions success:\(String(describing: completion))")
            }
        }
    }
    
    static func requestNotifications(completion: @escaping (Result<Bool,Error>) -> ()) {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        requestNotificationsRaw(options: options, completion: completion)
    }
    
}



