//
//  MercadoLibreServices.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

/// A namespace for Mercado Libre-specific network services and endpoint configuration.
///
/// This structure defines relevant enums for endpoints, path parameters, and query parameters
/// used to construct `Service` requests targeting Mercado Libre's product catalog.
struct MercadoLibreServices {
    
    /// Enumerates available Mercado Libre API endpoints.
    ///
    /// These values represent relative paths appended to the base URL provided by `NetworkManagerType`.
    /// Path parameters in curly braces (e.g., `{query}`) must be replaced by actual values via `Service.pathParams`.
    enum Endpoints: String {
        /// Search for active products within a specific site by query term.
        case getProducts = "products/search?status=active&site_id={siteID}&q={query}"
    }
    
    /// Keys for path parameters used in endpoint replacement.
    ///
    /// These must match the `{}` placeholders in endpoint paths.
    enum PathParams: String {
        case siteID = "site_id" // Example: "MLM" for Mexico
        case query = "query"
    }
  
  /// Optional query parameters that can be appended to the request URL.
  enum QueryParams: String {
      case isEnabled = "is_enabled"
  }
    
}

/// Conformance to `MercadoLibreServicesProtocol`, providing implementations for Mercado Libre-related services.
extension MercadoLibreServices: MercadoLibreServicesProtocol {
    
    /// Returns a `Service` configured to search for products on Mercado Libre by keyword.
    ///
    /// - Parameter query: The search term to use when querying the catalog (e.g., "tazas").
    /// - Returns: A configured `Service` instance expecting a response of type `SearchProductsModels.Response`.
    func getProducts(query: String) -> Service<SearchProductsModels.Response> {
        Service<SearchProductsModels.Response>(
            networkManagerType: .meli,
            endpoint: Endpoints.getProducts.rawValue,
            httpMethod: .get,
            pathParams: [
                PathParams.query.rawValue: query,
                PathParams.siteID.rawValue: AppConstants.siteID
            ]
        )
    }
}

