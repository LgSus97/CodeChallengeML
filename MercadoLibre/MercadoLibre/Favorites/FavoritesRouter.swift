//
//  FavoritesRouter.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//

import UIKit

/// Router responsible for building and navigating to the Favorites screen.
final class FavoritesRouter {

    // MARK: - Private Methods
    
    /// Builds the Favorites module and returns the configured view controller.
    private func buildFavoritesViewController() -> UIViewController {
        let view = FavoritesViewController()
        let interactor = FavoritesInteractor()
        view.interactor = interactor
        return view
    }
}

// MARK: - FavoritesRouterProtocol

extension FavoritesRouter: FavoritesRouterProtocol {
    
    /// Returns the configured view controller for the Favorites module.
    func getView() -> UIViewController {
        buildFavoritesViewController()
    }
    
    /// Pushes the Favorites screen onto the provided navigation controller.
    ///
    /// - Parameter navigation: The navigation controller to push the Favorites screen onto.
    func toView(navigation: UINavigationController?) {
        guard let navigationController = navigation else { return }
        let viewController = buildFavoritesViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Pops the current Favorites screen from the navigation stack.
    ///
    /// - Parameter navigation: The navigation controller managing the current view controller.
    func popFavoritesProducts(navigation: UINavigationController?) {
        navigation?.popViewController(animated: true)
    }
}
