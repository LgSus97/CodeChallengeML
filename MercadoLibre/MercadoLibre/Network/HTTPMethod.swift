//
//  HTTPMethod.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

/// Defines the types of HTTP methods used to perform requests.
///
/// This enumeration provides a type-safe representation of HTTP methods,
/// allowing for clear and concise specification of the method when constructing
/// HTTP requests.
public enum HTTPMethod: String, CaseIterable {
    /// Represents an HTTP GET request.
    /// Used to retrieve information from the server.
    case get = "GET"

    /// Represents an HTTP POST request.
    /// Used to send data to the server to create/update a resource.
    case post = "POST"

    /// Represents an HTTP PUT request.
    /// Used to send data to the server to create/update a resource.
    case put = "PUT"

    /// Represents an HTTP DELETE request.
    /// Used to delete a resource identified by a URI.
    case delete = "DELETE"

    /// Represents an HTTP PATCH request.
    /// Used to apply partial modifications to a resource.
    case patch = "PATCH"
}
