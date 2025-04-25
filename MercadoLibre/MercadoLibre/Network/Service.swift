//
//  Service.swift
//  MercadoLibre
//
//  Created by Jesus Loaiza Herrera on 24/04/25.
//

import Foundation

/// A generic service descriptor used to construct and configure HTTP requests for network communication.
///
/// The `Service` structure is designed to work with a centralized `NetworkManager` by defining
/// all necessary components for a network call, including:
/// - The base URL context (`networkManagerType`)
/// - The relative endpoint path
/// - Path and query parameters
/// - Custom headers
/// - Optional request body
/// - HTTP method
///
/// The associated generic type `ResponseModel` must conform to `Decodable` and represents the expected
/// response payload from the API.
///
/// ### Example:
/// ```swift
/// let service = Service<ProductListResponse>(
///     networkManagerType: .meli,
///     endpoint: "sites/{site_id}/search",
///     httpMethod: .get,
///     pathParams: ["site_id": "MLM"],
///     queryParams: ["q": "iphone"]
/// )
/// ```
struct Service<ResponseModel: Decodable> {
    
    /// The base URL category that determines the host (e.g., main API, auth, etc.).
    let networkManagerType: NetworkManagerType

    /// The endpoint path relative to the base URL.
    /// May include placeholders like `{id}` to be replaced with `pathParams`.
    let endpoint: String

    /// The HTTP method to use (GET, POST, PUT, DELETE, etc.).
    let httpMethod: HTTPMethod

    /// Dictionary of path parameters to replace placeholders in the endpoint.
    /// For example, `{site_id}` in the endpoint will be replaced by `["site_id": "MLM"]`.
    let pathParams: [String: Any]?

    /// Dictionary of query parameters to be appended to the URL as a query string.
    /// For example, `["q": "iphone"]` becomes `?q=iphone`.
    let queryParams: [String: Any]?

    /// Optional headers to include in the request.
    /// Useful for Authorization tokens or custom content types.
    let additionalHeaders: [String: Any]?

    /// Optional request body that conforms to `Encodable`, used in POST/PUT requests.
    let request: Encodable?

    /// Initializes a new instance of `Service`.
    ///
    /// - Parameters:
    ///   - networkManagerType: The domain type for determining the base URL.
    ///   - endpoint: Relative endpoint path, possibly containing path placeholders.
    ///   - httpMethod: The HTTP method to use.
    ///   - pathParams: Parameters to substitute into the endpoint string.
    ///   - queryParams: Query string parameters to be appended to the URL.
    ///   - additionalHeaders: Extra headers to include with the request.
    ///   - request: A request body payload, conforming to `Encodable`.
    init(
        networkManagerType: NetworkManagerType,
        endpoint: String,
        httpMethod: HTTPMethod,
        pathParams: [String: Any]? = nil,
        queryParams: [String: Any]? = nil,
        additionalHeaders: [String: Any]? = nil,
        request: Encodable? = nil
    ) {
        self.networkManagerType = networkManagerType
        self.endpoint = endpoint
        self.httpMethod = httpMethod
        self.pathParams = pathParams
        self.queryParams = queryParams
        self.additionalHeaders = additionalHeaders
        self.request = request
    }
}
