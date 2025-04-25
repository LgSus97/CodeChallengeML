//
//  MercadoLibreServicesProtocol.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

/// A protocol defining the available services for interacting with Mercado Libre APIs.
protocol MercadoLibreServicesProtocol {
    
    /// Retrieves a list of products based on the given search query.
    ///
    /// - Parameter query: The search keyword to filter products (e.g., "tazas").
    /// - Returns: A `Service` instance configured for the product search request.
    func getProducts(query: String) -> Service<SearchProductsModels.Response>
}
