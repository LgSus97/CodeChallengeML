//
//  SearchProductsVIP.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//
import UIKit

protocol SearchProductsViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    func showError()
    func displayData(products: [ProductView])
    func showEmptyState(showClearButton: Bool) 
}

protocol SearchProductsInteractorProtocol {
    func getProducts(from query: String)
    func saveSearch(_ query: String)
    func getHistory() -> [String]
    func getSuggestions(from query: String) -> [String]
    func filterSuggestions(from list: [String], with query: String) -> [String]
    func filterProducts(products: [ProductListItemViewModel], brand: String?, model: String?, color: String?) -> [ProductListItemViewModel]
    func extractAvailableFilters(
        from products: [ProductListItemViewModel]
    ) -> (brands: [String], models: [String], colors: [String])
}

protocol SearchProductsPresenterProtocol {
    func showLoader()
    func hideLoader()
    func showError()
    func displayData(products: [ProductView])
}

protocol SearchProductsRouterProtocol {
    func getView() -> UIViewController
    func toView(navigation: UINavigationController?)
    func popSearchProducts(navigation: UINavigationController?)
}
