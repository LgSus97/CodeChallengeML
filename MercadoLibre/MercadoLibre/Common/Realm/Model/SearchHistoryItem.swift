//
//  SearchHistoryItem.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import Foundation
import RealmSwift

final class SearchHistoryItem: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var query: String = ""
    @objc dynamic var createdAt: Date = Date()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(query: String, id: String? = nil) {
        self.init()
        self.query = query
        if let id = id {
            self.id = id
        }
    }
}
