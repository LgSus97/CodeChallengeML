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
