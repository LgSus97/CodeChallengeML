//
//  FavoritesManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 26/04/25.
//

import RealmSwift

/// Manages the list of favorite products, using Realm for local persistence.
final class FavoritesManager {
    
    /// Singleton instance of FavoritesManager.
    static let shared = FavoritesManager()
    
    /// Realm database instance.
    private let realm = try! Realm()

    /// Private initializer to enforce singleton usage.
    private init() {}

    /// Adds a product to favorites.
    /// - Parameter model: The product to be added as favorite.
    func addFavorite(model: ProductListItemViewModel) {
        let favorite = FavoriteProductModel.from(model: model)
        try? realm.write {
            realm.add(favorite, update: .modified)
        }
    }

    /// Removes a product from favorites by its ID.
    /// - Parameter id: The unique identifier of the product.
    func removeFavorite(id: String) {
        guard let object = realm.object(ofType: FavoriteProductModel.self, forPrimaryKey: id) else { return }
        try? realm.write {
            realm.delete(object)
        }
    }

    /// Checks if a product is already marked as favorite.
    /// - Parameter id: The unique identifier of the product.
    /// - Returns: `true` if the product is a favorite, otherwise `false`.
    func isFavorite(id: String) -> Bool {
        return realm.object(ofType: FavoriteProductModel.self, forPrimaryKey: id) != nil
    }

    /// Fetches all favorite products.
    /// - Returns: An array of `ProductListItemViewModel` representing the favorites.
    func fetchFavorites() -> [ProductListItemViewModel] {
        let favorites = realm.objects(FavoriteProductModel.self)
        return favorites.map { $0.toProductListItemViewModel() }
    }
}
