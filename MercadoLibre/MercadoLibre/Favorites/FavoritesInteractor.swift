//
//  FavoritesInteractor.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//


import Foundation

final class FavoritesInteractor: FavoritesInteractorProtocol {
    func getProducts() -> [ProductListItemViewModel] {
        FavoritesManager.shared.fetchFavorites()
    }

    func removeRemoveProduct(_ id: String) {
        FavoritesManager.shared.removeFavorite(id: id)
    }
}
