//
//  Item.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 08/10/2022.
//

import Foundation

fileprivate enum Constants {
    enum DictionaryKeys {
        static let id = "id"
        static let title = "title"
        static let isCompleted = "isCompleted"
    }
}

struct Item: Identifiable, Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    
    init(
        id: String = UUID().uuidString,
        title: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    init(keyId: String, dictionary: [String: Any]) {
        self.title = dictionary[Constants.DictionaryKeys.title] as? String ?? ""
        self.isCompleted = dictionary[Constants.DictionaryKeys.isCompleted] as? Bool ?? false
        self.id = keyId
    }
    
    func updateCompletion() -> Item {
        return Item(id: id, title: title, isCompleted: !isCompleted)
    }
}

extension Item {
    static let stubItem1 = Item(
        title: "stub",
        isCompleted: true
    )
    static let stubItem2 = Item(
        title: "stub2",
        isCompleted: false
    )
    static let stubItem3 = Item(
        title: "stub3",
        isCompleted: true
    )
}
