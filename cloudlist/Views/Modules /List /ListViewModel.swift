//
//  ListViewModel.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 08/10/2022.
//

import Foundation
import Combine

final class ListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var currentToDoItemText: String = ""
    @Published var shouldShakeView = false
    @Published var shakeOffset: CGFloat = 0
    
    private var domainModel: AppDomainModel
    
    private var cancellables = Set<AnyCancellable>()
    
    var isEmptyField: Bool {
        return currentToDoItemText.isEmpty
    }
    
    var itemsEmpty: Bool {
        return items.isEmpty
    }
    
    init(domainModel: AppDomainModel) {
        self.domainModel = domainModel
        // MARK: Subsciptions
        
        /// loading items from the domainModel
        domainModel.$items
            .assign(to: &$items)
        
        /// subscription to save items on change, should be moved to the domain model
//        $items
//            .dropFirst()
//            .sink { [weak self] items in
//                self?.saveItemsToDefaults(items: items)
//            }
//            .store(in: &cancellables)
    }
    
    // MARK: Input
    func position(of item: Item) -> Int {
        (items.firstIndex { $0.id == item.id } ?? 0) + 1
    }
    
    // MARK: View Output
    
    func viewWillAppear() {
        domainModel.viewWillApeear()
    }
    
    // MARK: Data Manupilation
    
    func deleteItem(indexSet: IndexSet) {
        domainModel.deleteItem(indexSet: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        domainModel.items.move(fromOffsets: from, toOffset: to)
    }
    
    func createAndAppend() {
        guard !currentToDoItemText.isEmpty else { return }
        domainModel.createAndAppend(item: .init(id: UUID().uuidString, title: currentToDoItemText))
    }
    
    func onUpdateItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            domainModel.items[index] = item.updateCompletion()
            domainModel.updateItem(item: item.updateCompletion())
        }
    }
    
    // MARK: Persistence
    
    func saveItems(items: [Item]) {
        domainModel.saveItemsToDefaults(items: items)
    }
}
