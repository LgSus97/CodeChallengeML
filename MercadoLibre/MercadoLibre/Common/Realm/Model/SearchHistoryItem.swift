//
//  SearchHistoryItem.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import Foundation
import RealmSwift

/// A Realm model representing a search history item.
final class SearchHistoryItem: Object {
    
    /// The unique identifier of the search item.
    @objc dynamic var id: String = UUID().uuidString
    
    /// The search query text.
    @objc dynamic var query: String = ""
    
    /// The date and time when the search was made.
    @objc dynamic var createdAt: Date = Date()

    /// Defines the primary key for the Realm object.
    override static func primaryKey() -> String? {
        return "id"
    }

    /// Convenience initializer to create a new search history item.
    /// - Parameters:
    ///   - query: The search text.
    ///   - id: An optional identifier. If none is provided, a UUID will be generated.
    convenience init(query: String, id: String? = nil) {
        self.init()
        self.query = query
        if let id = id {
            self.id = id
        }
    }
}
