//
//  SearchHistoryManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import Foundation
import RealmSwift

/// Manages search history records using Realm for local storage.
final class SearchHistoryManager {

    /// Realm database instance.
    private static let realm = try! Realm()
    
    /// Maximum number of search history items to keep.
    private static let maxItems = 10

    /// Saves a new search query or updates the timestamp if it already exists.
    /// - Parameters:
    ///   - query: The search text to save.
    ///   - id: An optional identifier associated with the query.
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

    /// Fetches the saved search history, sorted by most recent.
    /// - Returns: An array of `SearchHistoryItem` objects.
    static func fetch() -> [SearchHistoryItem] {
        let items = realm.objects(SearchHistoryItem.self)
            .sorted(byKeyPath: "createdAt", ascending: false)
        return Array(items)
    }

    /// Clears all saved search history items.
    static func clear() {
        try! realm.write {
            let allItems = realm.objects(SearchHistoryItem.self)
            realm.delete(allItems)
        }
    }
}
