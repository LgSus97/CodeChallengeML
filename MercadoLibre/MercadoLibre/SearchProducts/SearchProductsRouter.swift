//
//  SearchProductsRouter.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import UIKit

/// Router responsible for building and navigating to the Search Products screen.
final class SearchProductsRouter {

    // MARK: - Private Methods
    
    /// Builds the Search Products module and returns the configured view controller.
    private func buildSearchProductsViewController() -> UIViewController {
        let view = SearchProductsViewController()
        let presenter = SearchProductsPresenter(view: view)
        let interactor = SearchProductsInteractor(presenter: presenter)
        view.interactor = interactor
        return view
    }
}

// MARK: - SearchProductsRouterProtocol

extension SearchProductsRouter: SearchProductsRouterProtocol {
    /// Returns the configured view controller for the Search Products module.
    func getView() -> UIViewController {
        buildSearchProductsViewController()
    }
    
    /// Pushes the Search Products screen onto the provided navigation controller.
    ///
    /// - Parameter navigation: The navigation controller to push the new view controller onto.
    func toView(navigation: UINavigationController?) {
        guard let navigationController = navigation else { return }
        let viewController = buildSearchProductsViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    /// Pops the current Search Products screen from the navigation stack.
    ///
    /// - Parameter navigation: The navigation controller managing the current view controller.
    func popSearchProducts(navigation: UINavigationController?) {
        navigation?.popViewController(animated: true)
    }
}

