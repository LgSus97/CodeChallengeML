//
//  NetworkManagerProtocol.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

// MARK: - NetworkManagerProtocol -

/// `NetworkManagerProtocol` defines the methods required for a network manager that handles HTTP requests.
protocol NetworkManagerProtocol {
    
    ///
    /// The request is constructed with the specified base URL, endpoint, HTTP method, query parameters, body parameters, and any additional headers.
    /// Once the request completes, the result is returned via the completion handler as a `Result` containing either the decoded response model or an error.
    ///
    /// - Parameters:
    ///   - service: The service configuration for the request, containing details like base URL, endpoint, HTTP method, path parameters, query parameters, and body parameters.
    ///   - completion: A closure that is called when the request completes. It provides a `Result` with either a decoded `ResponseModel` on success or an error on failure.
    func performRequest<ResponseModel: Decodable>(
        service: Service<ResponseModel>,
        completion: @escaping((Result<ResponseModel, Error>) -> Void)
    )
}

/// Concrete implementation of `NetworkManagerProtocol` that delegates the work to `NetworkManager`.
final class CoreNetworkManager: NetworkManagerProtocol {
    
    func performRequest<ResponseModel: Decodable>(
        service: Service<ResponseModel>,
        completion: @escaping ((Result<ResponseModel, Error>) -> Void)
    ) {
        NetworkManager.shared.execute(service, completion: completion)
    }
}
