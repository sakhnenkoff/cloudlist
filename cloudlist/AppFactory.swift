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

struct AppFactory {
    static func createDomainModel() -> AppDomainModel {
        AppDomainModel(networkService: NetworkService(), persistenceService: PersistenceService())
    }
}
