//
//  AppFactory.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 13/10/2022.
//

import Foundation
import Combine
import Firebase

protocol NetworkServiceProtocol {
    func loadData(completion: @escaping ([Item]) -> ())
    func saveToDatabase(item: Item, completion: @escaping (Error?, DatabaseReference) -> ())
    func updateStatus(for item: Item, completion: @escaping (Error?, DatabaseReference) -> ())
    func deleteItem(_ id: String, completion: @escaping (Error?, DatabaseReference) -> ())
}
protocol PersistenceServiceProtocol {
    var itemPublisher: Published<[Item]>.Publisher { get }
    var defaults: UserDefaults { get }
    
    func loadData()
    func updateData(with items: [Item])
}

final class NetworkService: NetworkServiceProtocol {
    private enum Constants {
        static let itemsObject = "items"
    }
    
    private lazy var dbREF = Database.database().reference()
    
    // MARK: Uploading & Downloading Data
    
    func loadData(completion: @escaping ([Item]) -> ()) {
        var fetchedItems = [Item]()
        
        dbREF.child(Constants.itemsObject).observe(.childAdded) { [weak self] snapshot in
            guard let self = self else { return }
            self.fetchSingleItem(by: snapshot.key) { item in
                fetchedItems.append(item)
                completion(fetchedItems)
            }
        }
    }
    
    func fetchSingleItem(by keyId: String, completion: @escaping (Item) -> ()) {
        dbREF.child(Constants.itemsObject).child(keyId).observeSingleEvent(of: .value) { (snaphot, _) in
            guard let dict = snaphot.value as? [String: Any] else { return }
            completion(Item(keyId: keyId, dictionary: dict))
        }
    }
    
    func saveToDatabase(item: Item, completion: @escaping (Error?, DatabaseReference) -> ()){
        let dict = item.createDictionary()
        let id = dbREF.child(Constants.itemsObject).childByAutoId()
        id.updateChildValues(dict, withCompletionBlock: completion)
        id.updateChildValues(dict) { [weak self] error, ref in
            guard let self = self else { return }
            guard let key = id.key else { return } // handle error
            let value = [Item.Constants.DictionaryKeys.id: key]
            self.dbREF.child(Constants.itemsObject).child(key).updateChildValues(value, withCompletionBlock: completion)
        }
    }   
    
    // MARK: Updating Items
    
    func updateStatus(for item: Item, completion: @escaping (Error?, DatabaseReference) -> ()) {
        let values = item.createDictionary()
        dbREF.child(Constants.itemsObject).child(item.id).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func deleteItem(_ id: String, completion: @escaping (Error?, DatabaseReference) -> ()) {
        dbREF.child(Constants.itemsObject).child(id).removeValue(completionBlock: completion)
    }
}

final class PersistenceService: PersistenceServiceProtocol {
    private enum Constants {
        static let itemsDefaultsKey = "items"
    }
    
    @Published var fetchedItems: [Item] = []
     
    var itemPublisher: Published<[Item]>.Publisher { $fetchedItems }
    var defaults: UserDefaults = .standard
    
    func loadData() {
        guard
            let data = defaults.data(forKey: Constants.itemsDefaultsKey),
            let savedItems = try? JSONDecoder().decode([Item].self, from: data)
        else { return }
        
        self.fetchedItems = savedItems
    }
    
    func updateData(with items: [Item]) {
        if let encoded = try? JSONEncoder().encode(items) {
            defaults.set(encoded, forKey: Constants.itemsDefaultsKey)
        }
    }
}

struct AppFactory {
    static func createDomainModel() -> AppDomainModel {
        AppDomainModel(networkService: NetworkService(), persistenceService: PersistenceService())
    }
}
