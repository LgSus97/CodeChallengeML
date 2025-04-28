//
//  MockNetworkManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 28/04/25.
//


// MARK: - Mock NetworkManager

/// A mock implementation of `NetworkManagerProtocol` for testing network requests.
final class MockNetworkManager: NetworkManagerProtocol {
    
    /// Determines if the mock should return an error.
    var shouldReturnError = false
    
    /// The mocked response to return on success.
    var mockedResponse: Any? = nil
    
    /// The mocked error to return on failure.
    var mockedError: Error = NetworkError.emptyResponse
    
    func performRequest<ResponseModel>(
        service: Service<ResponseModel>,
        completion: @escaping (Result<ResponseModel, Error>) -> Void
    ) where ResponseModel: Decodable {
        
        print("MockNetworkManager.performRequest called")
        
        if shouldReturnError {
            print("Returning mock error")
            completion(.failure(mockedError))
            return
        }
        
        if let response = mockedResponse as? ResponseModel {
            print("Returning mock success")
            completion(.success(response))
        } else {
            print("Mock could not cast the response model, returning error")
            completion(.failure(NetworkError.emptyResponse))
        }
    }
}

// MARK: - Mock Presenter

/// A mock implementation of `SearchProductsPresenterProtocol` for testing UI presentation logic.
final class MockSearchProductsPresenter: SearchProductsPresenterProtocol {
    
    /// Tracks if showLoader was called.
    var didShowLoader = false
    
    /// Tracks if hideLoader was called.
    var didHideLoader = false
    
    /// Tracks if showError was called.
    var didShowError = false
    
    /// Tracks if displayData was called.
    var didDisplayProducts = false
    
    /// Tracks if showEmptyState was called.
    var didShowEmptyState = false
    
    /// Captures the error message shown, if any.
    var errorMessage: String?
    
    func showLoader() {
        didShowLoader = true
        print("showLoader called")
    }
    
    func hideLoader() {
        didHideLoader = true
        print("hideLoader called")
    }
    
    func showError(message: String) {
        didShowError = true
        errorMessage = message
        print("showError called with message: \(message)")
    }
    
    func displayData(products: [ProductListItemViewModel]) {
        didDisplayProducts = true
        print("displayData called with \(products.count) products")
    }
    
    func showEmptyState(showClearButton: Bool) {
        didShowEmptyState = true
        print("showEmptyState called, showClearButton: \(showClearButton)")
    }
}

