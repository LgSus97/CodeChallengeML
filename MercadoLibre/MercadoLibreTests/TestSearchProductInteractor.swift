//
//  TestSearchProductInteractor.swift
//  MercadoLibreTests
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import XCTest
@testable import MercadoLibre

// MARK: - SearchProductsInteractor

final class SearchProductsInteractor {
    
    // MARK: - Properties
    
    private var presenter: SearchProductsPresenterProtocol?
    private var networkManager: NetworkManagerProtocol
    private var services: MercadoLibreServicesProtocol
    private var searchHistory: [String] = []
    
    /// Artificial delay to simulate loader display. Default: 2 seconds.
    private let loaderDelay: TimeInterval

    // MARK: - Initializer
    
    init(
        presenter: SearchProductsPresenterProtocol?,
        networkManager: NetworkManagerProtocol = CoreNetworkManager(),
        services: MercadoLibreServicesProtocol = MercadoLibreServices(),
        loaderDelay: TimeInterval = 2.0
    ) {
        self.presenter = presenter
        self.networkManager = networkManager
        self.services = services
        self.loaderDelay = loaderDelay
        self.loadSearchHistory()
    }
    
    // MARK: - Private Methods

    /// Loads the search history from local storage.
    private func loadSearchHistory() {
        searchHistory = Array(SearchHistoryManager.fetch().map { $0.query })
    }
}

// MARK: - SearchProductsInteractorProtocol

extension SearchProductsInteractor: SearchProductsInteractorProtocol {
    
    func saveSearch(_ query: String) {
        SearchHistoryManager.save(query: query)
        loadSearchHistory()
    }
    
    func getHistory() -> [String] {
        return searchHistory
    }
    
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
    
    func extractAvailableFilters(from products: [ProductListItemViewModel]) -> (brands: [String], models: [String], colors: [String]) {
        let brands = Set(products.compactMap { $0.brand }).sorted()
        let models = Set(products.compactMap { $0.model }).sorted()
        let colors = Set(products.compactMap { $0.color }).sorted()
        return (brands, models, colors)
    }
    
    func reloadSearchHistory() {
        searchHistory = Array(SearchHistoryManager.fetch().map { $0.query }.prefix(10))
    }
    
    func getProducts(from query: String) {
        presenter?.showLoader()
        
        networkManager.performRequest(service: services.getProducts(query: query)) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    DispatchQueue.main.asyncAfter(deadline: .now() + (self?.loaderDelay ?? 2.0)) {
                        self?.presenter?.hideLoader()
                        guard let products = response.results, !products.isEmpty else {
                            self?.presenter?.showEmptyState(showClearButton: false)
                            self?.presenter?.showError(message: "No products found for \"\(query)\".")
                            return
                        }
                        let viewModels = products.compactMap { $0.toViewModel() }
                        self?.presenter?.displayData(products: viewModels)
                    }
                    
                case .failure:
                    self?.presenter?.hideLoader()
                    self?.presenter?.showEmptyState(showClearButton: false)
                    self?.presenter?.showError(message: "An unexpected error occurred. Please try again.")
                }
            }
        }
    }
}

// MARK: - SearchProductsInteractorTests

import XCTest
@testable import MercadoLibre

/// Unit tests for `SearchProductsInteractor`.
final class SearchProductsInteractorTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: SearchProductsInteractor!
    var presenter: MockSearchProductsPresenter!
    var networkManager: MockNetworkManager!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        presenter = MockSearchProductsPresenter()
        networkManager = MockNetworkManager()
        sut = SearchProductsInteractor(
            presenter: presenter,
            networkManager: networkManager,
            loaderDelay: 0.0
        )
    }
    
    override func tearDown() {
        sut = nil
        presenter = nil
        networkManager = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testGetProductsSuccess() {
        // Given
        let dummyResponse = SearchProductsModels.Response(
            keywords: "macbook",
            paging: SearchProductsModels.Response.Paging(total: 1, limit: 10, offset: 0),
            results: [
                SearchProductsModels.Response.Product(
                    id: "1",
                    name: "Test Product",
                    status: "active",
                    domainID: "MLM-CATEGORY",
                    siteID: "MLM",
                    attributes: [],
                    pictures: []
                )
            ]
        )
        
        networkManager.shouldReturnError = false
        networkManager.mockedResponse = dummyResponse

        // When
        sut.getProducts(from: "macbook")

        // Then
        XCTAssertTrue(presenter.didShowLoader)

        let expectation = expectation(description: "Waiting for success response")
        DispatchQueue.main.async {
            XCTAssertTrue(self.presenter.didHideLoader)
            XCTAssertTrue(self.presenter.didDisplayProducts)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetProductsFailure() {
        // Given
        networkManager.shouldReturnError = true

        // When
        sut.getProducts(from: "macbook")

        // Then
        XCTAssertTrue(presenter.didShowLoader)

        let expectation = expectation(description: "Waiting for error response")
        DispatchQueue.main.async {
            XCTAssertTrue(self.presenter.didHideLoader)
            XCTAssertTrue(self.presenter.didShowError)
            XCTAssertTrue(self.presenter.didShowEmptyState)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
