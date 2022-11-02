//
//  ListDomainModel.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 08/10/2022.
//

import SwiftUI
import Combine

final class AppDomainModel {
    @Published var items: [Item] = []
    @Published var isDataLoading = false
    
    // MARK: Dependencies
    private let networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: NetworkServiceProtocol,
        persistenceService: PersistenceServiceProtocol
    ) {
        self.networkService = networkService
        self.persistenceService = persistenceService
        
        $items.sink { items in
            print("\(items) 🐞")
        }
        .store(in: &cancellables)
    }
    
    func crateListViewModel() -> ListViewModel {
        ListViewModel(domainModel: self)
    }
    
    // MARK: Output
    
    func viewWillApeear() {
        fetchFromDatabase()
    }
    
    func createAndAppend(item: Item) {
        saveToDatabase(item: item)
    }
    
    func deleteItem(indexSet: IndexSet, items: [Item]) {
        // preserve all ids to be deleted to avoid indices confusing
        let idsToDelete = indexSet.compactMap { items[$0].id }
        
        _ = idsToDelete.compactMap { [weak self] id in
            self?.networkService.deleteItem(id) { error, _ in
                if error == nil {
                    DispatchQueue.main.async {
                        self?.items.removeAll { $0.id == id }
                    }
                }
            }
        }
    }
        
    // MARK: Networking
    
    /// load items and publishes them one by one from the databse
    ///
    /// should be optimised in the future
    func fetchFromDatabase() {
        networkService.loadData { [weak self] items in
            DispatchQueue.main.async {
                self?.items = items
                self?.isDataLoading = false
            }
        }
    }
    
    /// save newly created item to the database
    func saveToDatabase(item: Item) {
        isDataLoading = true
        networkService.saveToDatabase(item: item) { [weak self] error, _ in
            DispatchQueue.main.async {
                guard
                    error == nil else
                {
                    print(error?.localizedDescription)
                    self?.isDataLoading = false
                    self?.fetchFromDatabase()
                    return
                }
            }
        }
    }
    
    /// update status for the particular item in the database
    func updateItem(item: Item) {
        networkService.updateStatus(for: item) { error, _ in
            if let error { print(error.localizedDescription) }
        }
    }
    
//    func saveToDatabase(items: [Item]) {
//        networkService.saveToDatabase(items: items) { error, _ in
//            if let error { print(error.localizedDescription) }
//        }
//    }
    
    // MARK: Persistence
    
    func configurePersistence() {
        persistenceService.itemPublisher
            .assign(to: &$items)
    }
    
    func fetchFromDefaults() {
        persistenceService.loadData()
    }
    
    func saveItemsToDefaults(items: [Item]) {
        persistenceService.updateData(with: items)
    }
}
