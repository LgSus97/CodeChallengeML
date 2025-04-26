//
//  NetworkError.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//


import Foundation

/// Common errors that can occur during network requests.
enum NetworkError: Error {
    /// The URL could not be constructed properly.
    case invalidURL

    /// The request completed without returning any data.
    case emptyResponse
    
    /// The server responded with an unexpected HTTP status code (outside the 200–299 range).
        ///
        /// Use this to differentiate between types of server-side issues (e.g. 404, 500, etc.).
        ///
        /// - Parameter code: The HTTP status code returned by the server.
        case invalidStatusCode(Int)
}
