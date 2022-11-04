//
//  Item.swift
//  cloudlist
//
//  Created by Matvii Sakhnenko on 08/10/2022.
//

import Foundation

struct Item: Identifiable, Codable {
    enum Constants {
        enum DictionaryKeys {
            static let id = "id"
            static let title = "title"
            static let isCompleted = "isCompleted"
        }
    }
    
    let id: String
    let title: String
    let isCompleted: Bool
    
    init(
        id: String,
        title: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
    
    init(
        dictionary: [String: Any]
    ) {
        self.title = dictionary[Constants.DictionaryKeys.title] as? String ?? ""
        self.isCompleted = dictionary[Constants.DictionaryKeys.isCompleted] as? Bool ?? false
        self.id = dictionary[Constants.DictionaryKeys.id] as? String ?? ""
    }
    
    func updateCompletion() -> Item {
        return Item(id: id, title: title, isCompleted: !isCompleted)
    }
}

extension Item {
    func createDictionary() -> [AnyHashable: Any] {
        [
            Constants.DictionaryKeys.title: self.title,
            Constants.DictionaryKeys.isCompleted: self.isCompleted,
            Constants.DictionaryKeys.id: self.id
        ]
    }
}

extension Item {
    static let stubItem1 = Item(
        id: "dsafkjasdl",
        title: "stub",
        isCompleted: true
    )
    static let stubItem2 = Item(
        id: "dsafkjasdl",
        title: "stub2",
        isCompleted: false
    )
    static let stubItem3 = Item(
        id: "dsafkjasdl",
        title: "stub3",
        isCompleted: true
    )
}
