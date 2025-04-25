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
}
