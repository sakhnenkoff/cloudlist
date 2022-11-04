//
//  DefaultsPersistenceManager.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 03/11/2022.
//

import Foundation

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
