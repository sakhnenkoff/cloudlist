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
        
        persistenceService.itemPublisher
            .assign(to: &$items)
    }
    
    func crateListViewModel() -> ListViewModel {
        ListViewModel(domainModel: self)
    }
    
    // MARK: Output
    
    func viewWillApeear() {
        fetchFromDatabase()
    }
    
    // MARK: Networking
    
    func fetchFromDatabase() {
        networkService.loadData()
    }
    
    // MARK: Persistence
    
    func saveItems(items: [Item]) {
        persistenceService.updateData(with: items)
    }

}
