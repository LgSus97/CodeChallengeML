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
    /// - Parameter code: The HTTP status code returned by the server.
    case invalidStatusCode(Int)
}

extension NetworkError {

    /// Provides a user-friendly error message based on the type of network error.
    var userFriendlyMessage: String {
        switch self {
        case .invalidURL:
            return "La dirección del servidor es incorrecta. Por favor intenta más tarde."
        case .emptyResponse:
            return "No recibimos respuesta del servidor. Intenta nuevamente."
        case .invalidStatusCode(let code):
            switch code {
            case 400:
                return "Hubo un problema con tu solicitud. Por favor verifica los datos enviados."
            case 401, 403:
                return "No tienes permiso para realizar esta acción. Revisa tu sesión."
            case 404:
                return "No encontramos el recurso solicitado."
            case 500...599:
                return "Ocurrió un error interno en el servidor. Inténtalo más tarde."
            default:
                return "Ocurrió un error inesperado (código: \(code)). Intenta de nuevo."
            }
        }
    }
}

