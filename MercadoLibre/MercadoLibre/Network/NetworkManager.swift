//
//  NetworkManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

/// A singleton class responsible for executing HTTP requests defined by the `Service` structure.
final class NetworkManager {

    /// Shared instance of `NetworkManager`.
    static let shared = NetworkManager()

    /// Private initializer to enforce singleton pattern.
    private init() {}

    /// Executes a given `Service` request and decodes the response into the specified model.
    ///
    /// This method prepares the URL, path and query parameters, headers, and request body
    /// according to the provided `Service` configuration. It logs the request and response
    /// for debugging purposes.
    ///
    /// - Parameters:
    ///   - service: A generic `Service` configuration object containing request details.
    ///   - completion: Completion handler returning a `Result` with either the decoded model or an error.
    func execute<T: Decodable>(_ service: Service<T>, completion: @escaping (Result<T, Error>) -> Void) {
        let baseURL = service.networkManagerType.baseURL
        var endpoint = service.endpoint

        // Replace path parameters in the endpoint
        service.pathParams?.forEach { key, value in
            endpoint = endpoint.replacingOccurrences(of: "{\(key)}", with: "\(value)")
        }

        // Build URL with query parameters
        guard var components = URLComponents(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        if let queryParams = service.queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        guard let url = components.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = service.httpMethod.rawValue

        // Set default Authorization header
        request.setValue(AppConstants.accessToken, forHTTPHeaderField: "Authorization")

        // Apply additional headers if provided
        service.additionalHeaders?.forEach { key, value in
            request.setValue("\(value)", forHTTPHeaderField: key)
        }

        // Encode and attach request body if present
        if let body = service.request {
            do {
                request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(error))
                return
            }
        }

        // MARK: - Log Request
        logRequest(request)

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in

            // Log response body if available
            if let data = data {
                self.logResponse(data: data)
            }

            if let error = error {
                print(" Network Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.emptyResponse))
                return
            }

            //  Validate status code
            guard (200...299).contains(httpResponse.statusCode) else {
                print(" HTTP Error Code: \(httpResponse.statusCode)")
                completion(.failure(NetworkError.invalidStatusCode(httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.emptyResponse))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                print(" Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Private Helpers

    /// Logs the request details to the console, including URL, method, headers, and body.
    ///
    /// - Parameter request: The URLRequest being executed.
    private func logRequest(_ request: URLRequest) {
        print("\n📤 --- REQUEST ---")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")

        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("-----------------\n")
    }

    /// Logs the raw JSON response body to the console.
    ///
    /// - Parameter data: The raw data received from the network response.
    private func logResponse(data: Data) {
        if let jsonString = String(data: data, encoding: .utf8) {
            print("\n📥 --- RESPONSE ---")
            print(jsonString)
            print("-------------------\n")
        }
    }
}


/// A type-erased `Encodable` wrapper used to pass request bodies of any `Encodable` type.
///
/// This is useful when the request body is dynamic and the exact type is not known at compile-time.
struct AnyEncodable: Encodable {
  private let encodeFunc: (Encoder) throws -> Void
  
  init<T: Encodable>(_ wrapped: T) {
    self.encodeFunc = wrapped.encode
  }
  
  func encode(to encoder: Encoder) throws {
    try encodeFunc(encoder)
  }
}
