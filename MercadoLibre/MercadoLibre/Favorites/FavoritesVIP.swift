//
//  FavoritesVIP.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//


protocol FavoritesInteractorProtocol {
    func getProducts() ->  [ProductListItemViewModel]
    func removeRemoveProduct(_ id: String)
}
