//
//  SearchProductsInteractor.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

final class SearchProductsInteractor {
    
    // MARK: - Properties
    
    private var presenter: SearchProductsPresenterProtocol?
    private var networkManager: NetworkManagerProtocol
    private var services: MercadoLibreServicesProtocol
    
    private var searchHistory: [String] = []
    
    // MARK: - Initializers
    
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
    
    private func loadSearchHistory() {
        searchHistory = Array(SearchHistoryManager.fetch().map { $0.query })
    }

}

extension SearchProductsInteractor: SearchProductsInteractorProtocol {
    
    // MARK: - Network
    
    func getProducts(from query: String) {
        networkManager.performRequest(
            service: services.getProducts(query: query)
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.presenter?.hideLoader()
                
                switch result {
                case .success(let response):
                    guard let products = response.results else {
                        self?.presenter?.showError()
                        return
                    }
                    
                    let viewModels = products.compactMap { $0.toViewModel() }
                    self?.presenter?.displayData(products: viewModels)
                    
                case .failure:
                    self?.presenter?.showError()
                }
            }
        }
    }
    
    // MARK: - Persistence
    
    func saveSearch(_ query: String) {
        SearchHistoryManager.save(query: query)
        loadSearchHistory()
    }
    
    func getHistory() -> [String] {
        return searchHistory
    }
    
    func reloadSearchHistory() {
        let items = SearchHistoryManager.fetch().map { $0.query }
        searchHistory = Array(items.prefix(10))
    }
    
    // MARK: - Filtering
    
    func getSuggestions(from query: String) -> [String] {
        return searchHistory.filter { $0.lowercased().hasPrefix(query.lowercased()) }
    }
    
    func filterSuggestions(from list: [String], with query: String) -> [String] {
        return list.filter { $0.lowercased().hasPrefix(query.lowercased()) }
    }
    
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
    
    func extractAvailableFilters(
        from products: [ProductListItemViewModel]
    ) -> (brands: [String], models: [String], colors: [String]) {
        let brands = Set(products.compactMap { $0.brand }).sorted()
        let models = Set(products.compactMap { $0.model }).sorted()
        let colors = Set(products.compactMap { $0.color }).sorted()
        
        return (brands: brands, models: models, colors: colors)
    }


}
