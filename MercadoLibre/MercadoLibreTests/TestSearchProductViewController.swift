//
//  TestSearchProductViewController.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//


import XCTest
@testable import MercadoLibre


// MARK: - Mock Interactor

/// A mock implementation of `SearchProductsInteractorProtocol` for testing the ViewController.
final class MockSearchProductsInteractor: SearchProductsInteractorProtocol {
    
    // MARK: - State Tracking
    
    var didCallGetProducts = false
    var didCallSaveSearch = false
    var didCallGetHistory = false
    
    // MARK: - SearchProductsInteractorProtocol Methods
    
    func getProducts(from query: String) {
        didCallGetProducts = true
    }
    
    func saveSearch(_ query: String) {
        didCallSaveSearch = true
    }
    
    func getHistory() -> [String] {
        didCallGetHistory = true
        return ["MacBook", "iPhone"]
    }
    
    func reloadSearchHistory() {}
    
    func getSuggestions(from query: String) -> [String] {
        return []
    }
    
    func filterSuggestions(from list: [String], with query: String) -> [String] {
        return []
    }
    
    func filterProducts(products: [ProductListItemViewModel], brand: String?, model: String?, color: String?) -> [ProductListItemViewModel] {
        return products
    }
    
    func extractAvailableFilters(from products: [ProductListItemViewModel]) -> (brands: [String], models: [String], colors: [String]) {
        return (brands: [], models: [], colors: [])
    }
}

// MARK: - SearchProductsViewControllerTests

import XCTest
@testable import MercadoLibre

/// Unit tests for `SearchProductsViewController`.
final class SearchProductsViewControllerTests: XCTestCase {
    
    // MARK: - Properties
    
    var sut: SearchProductsViewController!
    var interactor: MockSearchProductsInteractor!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        sut = SearchProductsViewController()
        interactor = MockSearchProductsInteractor()
        sut.interactor = interactor

        _ = sut.view  // Force viewDidLoad
    }
    
    override func tearDown() {
        sut = nil
        interactor = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testWhenViewLoadsCallsGetProducts() {
        XCTAssertTrue(interactor.didCallGetProducts, "Expected getProducts to be called when the view loads")
    }
}
