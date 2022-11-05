//
//  NetworkService.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 03/11/2022.
//

import Foundation
import Firebase
import Combine

public enum NetworkError: String, Error, LocalizedError {
    case unableToLoadItems
    
    public var errorDescription: String {
       return rawValue
    }
}

final class NetworkService: NetworkServiceProtocol, ObservableObject {
    private enum Constants {
        static let itemsObject = "items"
    }
    
    @Published var user: User?
    
    private lazy var dbREF: DatabaseReference? = {
        guard let uid = Auth.auth().currentUser?.uid else {
        return nil
    }

      let ref = Database.database()
        .reference()
        .child("users/\(uid)/\(Constants.itemsObject)")
      return ref
    }()
    
    private let encoder = JSONEncoder()
    
    // MARK: Dependencies
    internal var authService: AuthenticationService
    internal weak var domainModel: AppDomainModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthenticationService) {
        self.authService = authService
        authService.networkService = self
        
        $user
            .sink { [weak self] in
                guard let self = self else { return }
                self.domainModel?.user = $0
            }
            .store(in: &cancellables)
    }
    
    // MARK: Uploading & Downloading Data
    func loadData(completion: @escaping (Result<[Item], NetworkError>) -> ()) {
        dbREF?.observeSingleEvent(of: .value) { [weak self] snapshot, error in
            guard let self = self else { return }
            if let items = self.mapRemoteItems(firebaseDictionary: snapshot.value) {
                completion(.success(items))
            } else {
                completion(.failure(.unableToLoadItems))
            }
        }
    }
    
    func mapRemoteItems(firebaseDictionary: Any?) -> [Item]? {
        guard let data = firebaseDictionary as? [String: [String: Any]] else { return nil }
        return data.compactMap { Item(dictionary: $0.value) }
    }

    func saveToDatabase(item: Item, completion: @escaping (Error?, DatabaseReference) -> ()) {
        let dict = item.createDictionary()
        let id = dbREF?.childByAutoId()
        id?.updateChildValues(dict, withCompletionBlock: completion)
        
        id?.updateChildValues(dict) { [weak self] error, ref in
            guard let self = self, let key = id?.key else { return }
        
            let value = [Item.Constants.DictionaryKeys.id: key]
            self.dbREF?.child(key).updateChildValues(value, withCompletionBlock: completion)
        }
    }
    
    // MARK: Updating Items
    func updateStatus(for item: Item, completion: @escaping (Error?, DatabaseReference) -> ()) {
        let values = item.createDictionary()
        dbREF?.child(item.id).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func deleteItem(_ id: String, completion: @escaping (Error?, DatabaseReference) -> ()) {
        dbREF?.child(id).removeValue(completionBlock: completion)
    }
}

// MARK: Auth Methods
extension NetworkService {
    func listenToAuthState() {
        authService.listenToAuthState()
    }
}
