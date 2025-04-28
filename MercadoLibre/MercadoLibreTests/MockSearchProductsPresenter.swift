//
//  MockSearchProductsPresenter.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//


import XCTest
@testable import MercadoLibre

/// A mock implementation of `SearchProductsPresenterProtocol` for testing UI presentation logic.
final class MockSearchProductsPresenter: SearchProductsPresenterProtocol {

    // MARK: - State Tracking

    /// Tracks if `showLoader` was called.
    var didShowLoader = false
    
    /// Tracks if `hideLoader` was called.
    var didHideLoader = false
    
    /// Tracks if `showError` was called.
    var didShowError = false
    
    /// Tracks if `showEmptyState` was called.
    var didShowEmptyState = false
    
    /// Tracks if `displayData` was called.
    var didDisplayProducts = false
    
    /// Captures the error message passed to `showError`.
    var errorMessage: String?

    // MARK: - SearchProductsPresenterProtocol Methods

    func showLoader() {
        didShowLoader = true
    }
    
    func hideLoader() {
        didHideLoader = true
    }
    
    func showError(message: String) {
        didShowError = true
        errorMessage = message
    }
    
    func showEmptyState(showClearButton: Bool = false) {
        didShowEmptyState = true
    }
    
    func displayData(products: [ProductListItemViewModel]) {
        didDisplayProducts = true
    }
}
