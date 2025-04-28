//
//  FavoritesVIP.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//

import UIKit

protocol FavoritesInteractorProtocol {
    func getProducts() ->  [ProductListItemViewModel]
    func removeRemoveProduct(_ id: String)
}

protocol FavoritesRouterProtocol {
    func getView() -> UIViewController
    func toView(navigation: UINavigationController?)
    func popFavoritesProducts(navigation: UINavigationController?)
}

