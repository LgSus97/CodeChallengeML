//
//  NetworkManager.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

func execute<T: Decodable>(_ service: Service<T>, completion: @escaping (Result<T, Error>) -> Void) {
  let baseURL = service.networkManagerType.baseURL
  var endpoint = service.endpoint
  
  // Replace path parameters
  service.pathParams?.forEach { key, value in
    endpoint = endpoint.replacingOccurrences(of: "{\(key)}", with: "\(value)")
  }
  
  // Build URL
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
  
  // Set default Authorization header from AppConstants
  request.setValue(AppConstants.accessToken, forHTTPHeaderField: "Authorization")
  
  // Apply additional headers (overrides Authorization if redefined)
  service.additionalHeaders?.forEach { key, value in
    request.setValue("\(value)", forHTTPHeaderField: key)
  }
  
  // Add request body if any
  if let body = service.request {
    do {
      request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    } catch {
      completion(.failure(error))
      return
    }
  }
  
  // Execute request
  URLSession.shared.dataTask(with: request) { data, _, error in
    if let error = error {
      completion(.failure(error))
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
      completion(.failure(error))
    }
  }.resume()
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
