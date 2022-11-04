//
//  NetworkManager.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 03/11/2022.
//

import Foundation
import Firebase

final class NetworkService: NetworkServiceProtocol {
    private enum Constants {
        static let itemsObject = "items"
    }
    
    private lazy var dbREF = Database.database().reference()
    
    // MARK: Uploading & Downloading Data
    func loadData(completion: @escaping ([Item]) -> ()) {
        dbREF.child(Constants.itemsObject).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            if let items = self.mapRemoteItems(firebaseDictionary: snapshot.value) {
                completion(items)
            }
            #warning("error should be handled")
        }
    }
    
    func mapRemoteItems(firebaseDictionary: Any?) -> [Item]? {
        guard let data = firebaseDictionary as? [String: [String: Any]] else { return nil }
        return data.compactMap { Item(dictionary: $0.value) }
    }

    func saveToDatabase(item: Item, completion: @escaping (Error?, DatabaseReference) -> ()) {
        let dict = item.createDictionary()
        let id = dbREF.child(Constants.itemsObject).childByAutoId()
        id.updateChildValues(dict, withCompletionBlock: completion)
        
        id.updateChildValues(dict) { [weak self] error, ref in
            guard let self = self, let key = id.key else { return } // handle error
            
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
