//
//  AppFactory.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 13/10/2022.
//

import Foundation
import Combine
import Firebase

protocol DataManagerProtocol {
    func loadData()
    func updateData(with items: [Item])
}

protocol NetworkServiceProtocol: DataManagerProtocol {}
protocol PersistenceServiceProtocol: DataManagerProtocol {
    var itemPublisher: Published<[Item]>.Publisher { get }
    var defaults: UserDefaults { get }
}

final class NetworkService: NetworkServiceProtocol {
    private enum Constants {
        static let itemsObject = "items"
    }
    
    private lazy var dbREF = Database.database().reference()
    
    func loadData() {
        dbREF.child(Constants.itemsObject).observe(.childAdded) { snapshot in
            print(snapshot)
        }
        
        fetchSingleItem(by: "item1")
    }
    
    func fetchSingleItem(by keyId: String) {
        dbREF.child(Constants.itemsObject).observeSingleEvent(of: .value) { (snaphot, _l) in
            guard let dict = snaphot.value as? [String: Any] else { return }
            let item = Item(keyId: keyId, dictionary: dict)
            print(item)
        }
    }
    
    func updateData(with items: [Item]) {
        print("data has been updated")
    }
}

final class PersistenceService: PersistenceServiceProtocol {
    private enum Constants {
        static let itemsDefaultsKey = "items"
    }
    
    @Published var fetchedItems: [Item] = []
     
    var itemPublisher: Published<[Item]>.Publisher { $fetchedItems }
    var defaults: UserDefaults = .standard
    
    init() {
        loadData()
    }
    
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
