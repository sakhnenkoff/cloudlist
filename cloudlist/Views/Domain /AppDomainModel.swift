//
//  ListDomainModel.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 08/10/2022.
//

import SwiftUI
import Combine
import FirebaseAuth

final class AppDomainModel: ObservableObject {
    @Published var user: User?
    @Published var items: [Item] = []
    @Published var rawItems: [Item] = []
    @Published var isDataLoading = false
    
    // MARK: Dependencies
    internal var networkService: NetworkServiceProtocol
    private let persistenceService: PersistenceServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        networkService: NetworkServiceProtocol,
        persistenceService: PersistenceServiceProtocol
    ) {
        self.persistenceService = persistenceService
        self.networkService = networkService
        
        self.networkService.domainModel = self
        
        $rawItems
            .map { $0.sorted { $0.isCompleted && !$1.isCompleted } }
            .assign(to: &$items)
    }
    
    // MARK: Output
    func viewWillApeear() {
        fetchFromDatabase()
    }
    
    func createAndAppend(item: Item) {
        saveToDatabase(item: item)
    }
    
    func deleteItem(indexSet: IndexSet) {
        fetchFromDatabase { [weak self] in
            guard let self = self else { return }
            let idsToDelete = indexSet.compactMap { self.items[$0].id }
            
            _ = idsToDelete.compactMap { [weak self] id in
                self?.networkService.deleteItem(id) { error, _ in
                    if error == nil {
                        DispatchQueue.global().sync {
                            self?.items.removeAll { $0.id == id }
                        }
                    }
                }
            }
        }
    }
        
    // MARK: Networking
    
    /// load items and publishes them one by one from the databse
    ///
    /// should be optimised in the future
    func fetchFromDatabase(completion: (() -> Void)? = nil) {
        isDataLoading = true
        networkService.loadData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(items):
                    self?.rawItems = items
                    self?.isDataLoading = false
                    completion?()
                case let .failure(error):
                    print(error.errorDescription)
                    self?.isDataLoading = false
                    completion?()
                }
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
                    self?.isDataLoading = false
                    return
                }
                self?.isDataLoading = false
                self?.fetchFromDatabase()
            }
        }
    }
    
    /// update status for the particular item in the database
    func updateItem(item: Item) {
        isDataLoading = true
        
        networkService.updateStatus(for: item) { [weak self] error, _ in
            if let error { print(error.localizedDescription) }
            self?.fetchFromDatabase()
        }
    }
    
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

// MARK: ViewModel Assembly
extension AppDomainModel {
    func createListViewModel() -> ListViewModel {
        ListViewModel(domainModel: self)
    }
}
