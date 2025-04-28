//
//  SearchProductsModels.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation
import UIKit
import RealmSwift

/// Models used to decode the search products API response from Mercado Libre.
struct SearchProductsModels: Codable {
    
    // MARK: - Response

    struct Response: Codable {
        let keywords: String?
        let paging: Paging?
        let results: [Product]?
        
        // MARK: - Paging
        
        struct Paging: Codable {
            let total: Int?
            let limit: Int?
            let offset: Int?
        }
        
        // MARK: - Product
        
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
        
        // MARK: - ProductAttribute
        
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
        
        // MARK: - ProductPicture
        
        struct ProductPicture: Codable {
            let id: String?
            let url: String?
        }
    }
}

// MARK: - Search State

/// Represents the different states during a product search.
enum SearchState {
    case idle          // No input yet
    case suggesting    // User is typing
    case results       // Products found
    case empty         // No products found
}

// MARK: - Product ViewModel

/// ViewModel used to represent a product in the search results list.
///
/// This model abstracts only the necessary information needed for displaying
/// the product in a table or collection view.
public struct ProductListItemViewModel {
    var id: String
    var name: String
    var imageUrl: URL?
    var brand: String?
    var model: String?
    var color: String?
    var badges: [ProductBadge]
    var isFavorite: Bool = false
}

// MARK: - Product Badges

/// Represents badges or highlights for a product (e.g., free shipping).
enum ProductBadge: String, PersistableEnum {
    case freeShipping
    case limitedStock
    case internationalShipping
}

// MARK: - Mapping to ViewModel

extension SearchProductsModels.Response.Product {

    /// Converts a `Product` model to a `ProductListItemViewModel`.
    /// - Returns: A mapped `ProductListItemViewModel`, or nil if essential fields are missing.
    func toViewModel() -> ProductListItemViewModel? {
        guard let id = id, let name = name else { return nil }
        
        let imageUrl = pictures?.first?.url.flatMap { URL(string: $0) }
        
        var randomBadges: [ProductBadge] = []
        if Bool.random() { randomBadges.append(.freeShipping) }
        if Bool.random() { randomBadges.append(.limitedStock) }
        if Bool.random() { randomBadges.append(.internationalShipping) }
        
        return ProductListItemViewModel(
            id: id,
            name: name,
            imageUrl: imageUrl,
            brand: brandName(),
            model: modelName(),
            color: colorName(),
            badges: randomBadges
        )
    }
}

// MARK: - Attribute Extraction Helpers

extension SearchProductsModels.Response.Product {
    
    /// Returns the product brand if available.
    func brandName() -> String? {
        return attributes?.first(where: { $0.id == "BRAND" })?.valueName
    }
    
    /// Returns the product model if available.
    func modelName() -> String? {
        return attributes?.first(where: { $0.id == "MODEL" })?.valueName
    }
    
    /// Returns the product color if available.
    func colorName() -> String? {
        return attributes?.first(where: { $0.id == "COLOR" })?.valueName
    }
}
