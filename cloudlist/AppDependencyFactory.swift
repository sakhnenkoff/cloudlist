//
//  AppDependencyFactory.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 13/10/2022.
//

import Foundation
import Combine
import Firebase
import FirebaseAuth

protocol NetworkServiceProtocol {
    var user: User? { get }
    var authService: AuthenticationService { get }
    var domainModel: AppDomainModel? { get set }
    
    func loadData(completion: @escaping (Result<[Item], NetworkError>) -> ()) -> ()
    func saveToDatabase(item: Item, completion: @escaping (Error?, DatabaseReference) -> ())
    func updateStatus(for item: Item, completion: @escaping (Error?, DatabaseReference) -> ())
    func deleteItem(_ id: String, completion: @escaping (Error?, DatabaseReference) -> ())
    func listenToAuthState()
}
protocol PersistenceServiceProtocol {
    var itemPublisher: Published<[Item]>.Publisher { get }
    var defaults: UserDefaults { get }
    
    func loadData()
    func updateData(with items: [Item])
}

struct AppDependencyFactory {
    static func createDomainModel() -> AppDomainModel {
        AppDomainModel(networkService: NetworkService(authService: AuthenticationService()), persistenceService: PersistenceService())
    }
}
