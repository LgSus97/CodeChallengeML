//
//  SearchHistoryManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import Foundation
import RealmSwift

final class SearchHistoryManager {

    private static let realm = try! Realm()
    private static let maxItems = 10

    static func save(query: String, id: String? = nil) {
        try! realm.write {
            if let existing = realm.objects(SearchHistoryItem.self).filter("query == %@", query).first {
                existing.createdAt = Date()
            } else {
                let item = SearchHistoryItem(query: query, id: id)
                realm.add(item)
            }

            let allItems = realm.objects(SearchHistoryItem.self)
                .sorted(byKeyPath: "createdAt", ascending: false)

            if allItems.count > maxItems {
                let itemsToDelete = allItems.suffix(from: maxItems)
                realm.delete(itemsToDelete)
            }
        }
    }


    static func fetch() -> [SearchHistoryItem] {
        let items = realm.objects(SearchHistoryItem.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
        return Array(items)
    }

    static func clear() {
        try! realm.write {
            let allItems = realm.objects(SearchHistoryItem.self)
            realm.delete(allItems)
        }
    }
}
