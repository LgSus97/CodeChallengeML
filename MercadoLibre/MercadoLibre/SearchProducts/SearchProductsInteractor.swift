//
//  SearchProductsInteractor.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

/// Handles search operations, history management, and product filtering logic.
final class SearchProductsInteractor {

    // MARK: - Properties

    private var presenter: SearchProductsPresenterProtocol?
    private var networkManager: NetworkManagerProtocol
    private var services: MercadoLibreServicesProtocol
    private var searchHistory: [String] = []

    // MARK: - Initializer

    /// Initializes the interactor with optional presenter, network manager, and services.
    init(
        presenter: SearchProductsPresenterProtocol?,
        networkManager: NetworkManagerProtocol = CoreNetworkManager(),
        services: MercadoLibreServicesProtocol = MercadoLibreServices()
    ) {
        self.presenter = presenter
        self.networkManager = networkManager
        self.services = services
        self.loadSearchHistory()
    }

    // MARK: - Private Methods

    /// Loads the saved search history from local storage.
    private func loadSearchHistory() {
        searchHistory = Array(SearchHistoryManager.fetch().map { $0.query })
    }
}

// MARK: - SearchProductsInteractorProtocol

extension SearchProductsInteractor: SearchProductsInteractorProtocol {

    // MARK: - Network

    /// Fetches products based on the search query and updates the presenter with results.
    /// - Parameter query: The search query string.
    func getProducts(from query: String) {
        presenter?.showLoader()
        networkManager.performRequest(
            service: services.getProducts(query: query)
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self?.presenter?.hideLoader()
                        guard let products = response.results, !products.isEmpty else {
                            self?.presenter?.showEmptyState(showClearButton: false)
                            self?.presenter?.showError(message: "No encontramos productos para \"\(query)\".")
                            return
                        }
                        let viewModels = products.compactMap { $0.toViewModel() }
                        self?.presenter?.displayData(products: viewModels)
                    }
                    
                case .failure(let error):
                    self?.presenter?.hideLoader()
                    self?.presenter?.showEmptyState(showClearButton: false)
                    self?.presenter?.showError(message: (error as? NetworkError)?.userFriendlyMessage ?? "Ocurrió un error inesperado. Inténtalo de nuevo.")
                }
            }
        }
    }

    // MARK: - Persistence

    /// Saves a new search query into history.
    /// - Parameter query: The search text to save.
    func saveSearch(_ query: String) {
        SearchHistoryManager.save(query: query)
        loadSearchHistory()
    }

    /// Retrieves the current search history.
    /// - Returns: An array of search query strings.
    func getHistory() -> [String] {
        return searchHistory
    }

    /// Reloads the search history from storage, limiting to the last 10 items.
    func reloadSearchHistory() {
        let items = SearchHistoryManager.fetch().map { $0.query }
        searchHistory = Array(items.prefix(10))
    }

    // MARK: - Filtering

    /// Returns search suggestions based on a partial query.
    /// - Parameter query: The text to match against saved searches.
    /// - Returns: A filtered list of matching search queries.
    func getSuggestions(from query: String) -> [String] {
        return searchHistory.filter { $0.lowercased().hasPrefix(query.lowercased()) }
    }

    /// Filters a given list of suggestions by a query.
    /// - Parameters:
    ///   - list: The list of suggestions to filter.
    ///   - query: The text to filter with.
    /// - Returns: A filtered list of suggestions.
    func filterSuggestions(from list: [String], with query: String) -> [String] {
        return list.filter { $0.lowercased().hasPrefix(query.lowercased()) }
    }

    /// Filters a list of products by brand, model, and color.
    /// - Parameters:
    ///   - products: The list of products to filter.
    ///   - brand: The brand to match (optional).
    ///   - model: The model to match (optional).
    ///   - color: The color to match (optional).
    /// - Returns: A filtered list of products.
    func filterProducts(
        products: [ProductListItemViewModel],
        brand: String?,
        model: String?,
        color: String?
    ) -> [ProductListItemViewModel] {
        return products.filter { product in
            let matchesBrand = brand == nil || product.brand?.lowercased() == brand?.lowercased()
            let matchesModel = model == nil || product.model?.lowercased() == model?.lowercased()
            let matchesColor = color == nil || product.color?.lowercased() == color?.lowercased()
            return matchesBrand && matchesModel && matchesColor
        }
    }

    /// Extracts unique brands, models, and colors available in a list of products.
    /// - Parameter products: The list of products.
    /// - Returns: A tuple containing arrays of brands, models, and colors.
    func extractAvailableFilters(
        from products: [ProductListItemViewModel]
    ) -> (brands: [String], models: [String], colors: [String]) {
        let brands = Set(products.compactMap { $0.brand }).sorted()
        let models = Set(products.compactMap { $0.model }).sorted()
        let colors = Set(products.compactMap { $0.color }).sorted()
        
        return (brands: brands, models: models, colors: colors)
    }
}
