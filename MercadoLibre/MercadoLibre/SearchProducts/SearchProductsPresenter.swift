//
//  SearchProductsPresenter.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

/// Handles presentation logic for the search products flow.
class SearchProductsPresenter {
    
    // MARK: - Properties
    
    weak var view: SearchProductsViewProtocol?
    
    // MARK: - Initializer
    
    /// Initializes the presenter with a reference to the view.
    /// - Parameter view: The view conforming to `SearchProductsViewProtocol`.
    init(view: SearchProductsViewProtocol?) {
        self.view = view
    }
}

// MARK: - SearchProductsPresenterProtocol

extension SearchProductsPresenter: SearchProductsPresenterProtocol {
    
    /// Displays an empty state on the view.
    /// - Parameter showClearButton: Indicates whether the clear button should be shown.
    func showEmptyState(showClearButton: Bool) {
        view?.showEmptyState(showClearButton: showClearButton)
    }
    
    /// Displays a list of products on the view.
    /// - Parameter products: The products to display.
    func displayData(products: [ProductListItemViewModel]) {
        view?.displayData(products: products)
    }
    
    /// Shows a loading indicator on the view.
    func showLoader() {
        view?.showLoader()
    }
    
    /// Hides the loading indicator on the view.
    func hideLoader() {
        view?.hideLoader()
    }
    
    /// Displays an error message on the view.
    /// - Parameter message: The error message to show.
    func showError(message: String) {
        view?.showError(message: message)
    }
}
