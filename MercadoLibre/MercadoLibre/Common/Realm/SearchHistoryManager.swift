//
//  SearchHistoryManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import RealmSwift

final class SearchHistoryManager {

    private static let realm = try! Realm()
    private static let maxItems = 10

    static func save(query: String, id: String? = nil) {
        let item = SearchHistoryItem(query: query, id: id)
        
        try! realm.write {
            realm.add(item, update: .modified)
            
            // Limitar a 10
            let allItems = realm.objects(SearchHistoryItem.self)
                .sorted(byKeyPath: "query", ascending: true)

            if allItems.count > maxItems {
                let itemsToDelete = allItems.prefix(allItems.count - maxItems)
                realm.delete(itemsToDelete)
            }
        }
    }

    static func fetch() -> [SearchHistoryItem] {
        let items = realm.objects(SearchHistoryItem.self)
            .sorted(byKeyPath: "query", ascending: true)
        return Array(items)
    }

    static func clear() {
        try! realm.write {
            let allItems = realm.objects(SearchHistoryItem.self)
            realm.delete(allItems)
        }
    }
}
