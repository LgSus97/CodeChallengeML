//
//  FavoritesInteractor.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//


import Foundation

/// Handles business logic related to favorite products.
final class FavoritesInteractor: FavoritesInteractorProtocol {
    
    // MARK: - Public Methods
    
    /// Retrieves the list of favorite products.
    /// - Returns: An array of `ProductListItemViewModel`.
    func getProducts() -> [ProductListItemViewModel] {
        FavoritesManager.shared.fetchFavorites()
    }

    /// Removes a product from favorites by its ID.
    /// - Parameter id: The unique identifier of the product to remove.
    func removeRemoveProduct(_ id: String) {
        FavoritesManager.shared.removeFavorite(id: id)
    }
}
