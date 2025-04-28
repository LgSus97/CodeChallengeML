//
//  FavoritesManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import RealmSwift

final class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let realm = try! Realm()

    private init() {}

    func addFavorite(model: ProductListItemViewModel) {
        let favorite = FavoriteProductModel.from(model: model)
        try? realm.write {
            realm.add(favorite, update: .modified)
        }
    }

    func removeFavorite(id: String) {
        guard let object = realm.object(ofType: FavoriteProductModel.self, forPrimaryKey: id) else { return }
        try? realm.write {
            realm.delete(object)
        }
    }

    func isFavorite(id: String) -> Bool {
        return realm.object(ofType: FavoriteProductModel.self, forPrimaryKey: id) != nil
    }

    func fetchFavorites() -> [ProductListItemViewModel] {
        let favorites = realm.objects(FavoriteProductModel.self)
        return favorites.map { $0.toProductListItemViewModel() }
    }
}
