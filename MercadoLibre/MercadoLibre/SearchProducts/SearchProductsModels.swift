//
//  SearchProductsModels.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

/// Models used to decode the search products API response from Mercado Libre.
struct SearchProductsModels: Codable {
    
    struct Response: Codable {
        let keywords: String?
        let paging: Paging?
        let results: [Product]?
        
        struct Paging: Codable {
            let total: Int?
            let limit: Int?
            let offset: Int?
        }
        
        struct Product: Codable {
            let id: String?
            let name: String?
            let status: String?
            let domainID: String?
            let siteID: String?
            let attributes: [ProductAttribute]?
            let pictures: [ProductPicture]?
            
            enum CodingKeys: String, CodingKey {
                case id, name, status, attributes, pictures
                case domainID = "domain_id"
                case siteID = "site_id"
            }
        }
        
        struct ProductAttribute: Codable {
            let id: String?
            let name: String?
            let valueID: String?
            let valueName: String?
            
            enum CodingKeys: String, CodingKey {
                case id, name
                case valueID = "value_id"
                case valueName = "value_name"
            }
        }
        
        struct ProductPicture: Codable {
            let id: String?
            let url: String?
        }
    }
}


enum SearchState {
    case idle          // no se ha escrito nada
    case suggesting    // está escribiendo
    case results       // productos encontrados
    case empty         // no se encontraron resultados
}


/// ViewModel used to represent a product in the search results list.
///
/// This model abstracts only the necessary information needed for displaying
/// the product in a table or collection view.
public struct ProductListItemViewModel {
    
    /// The unique identifier of the product.
    let id: String
    
    /// The product name or title.
    let name: String
    
    /// The URL of the product's main image.
    let imageUrl: URL?
    
    let brand: String?
    let model: String?
    let color: String?
}

extension SearchProductsModels.Response.Product {
    
    func toViewModel() -> ProductView? {
        guard let id = id, let name = name else { return nil }
        
        let imageUrl = pictures?.first?.url.flatMap { URL(string: $0) }
       
        
        return .init(
            data: ProductListItemViewModel(
                id: id,
                name: name,
                imageUrl: imageUrl,
                brand: brandName(),
                model: modelName(),
                color: colorName()
            )
        )
    }
}


extension SearchProductsModels.Response.Product {
    
    /// Returns the brand if available.
    func brandName() -> String? {
        return attributes?.first(where: { $0.id == "BRAND" })?.valueName
    }
    
    /// Returns the model if available.
    func modelName() -> String? {
        return attributes?.first(where: { $0.id == "MODEL" })?.valueName
    }
    
    /// Returns the color if available.
    func colorName() -> String? {
        return attributes?.first(where: { $0.id == "COLOR" })?.valueName
    }
}
