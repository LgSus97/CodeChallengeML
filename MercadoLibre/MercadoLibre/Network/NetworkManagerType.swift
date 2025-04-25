//
//  NetworkManagerType.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

/// - Note: Extend this enum as needed to support new domains or microservices.
enum NetworkManagerType {
    
    /// Mercado Libre's main API domain.
    case meli
    
    /// Authentication domain, typically used for OAuth or login flows.
    case auth

    /// The base URL associated with the specific network manager type.
    var baseURL: String {
        switch self {
        case .meli:
            return "https://api.mercadolibre.com/"
        case .auth:
            return "https://auth.mercadolibre.com/"
        }
    }
}
