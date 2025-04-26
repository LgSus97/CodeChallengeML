//
//  SearchHistoryItem.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import RealmSwift

final class SearchHistoryItem: Object {
    @Persisted(primaryKey: true) var query: String
    @Persisted var id: String?
    
    convenience init(query: String, id: String? = nil) {
        self.init()
        self.query = query
        self.id = id
    }
}
