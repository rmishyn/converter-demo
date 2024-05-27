//
//  API.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import Foundation
import Alamofire

public typealias Query = [String: String]

protocol API {
    var baseURL: URL {get}
    var defaultAcceptType: HTTPContentType {get}
    var defaultContentType: HTTPContentType {get}
    init(appConfiguration: AppConfiguration)
    func request(endpoint: APIEndpoint) throws -> URLRequestConvertible
}

protocol APIPath {
    var path: String {get}
}

protocol APIEndpoint {
    /// Endpoint relative path (to base url)
    var path: APIPath {get}
    /// HTTP method of request
    var method: HTTPMethod {get}
    /// Body parameters - to be serialized as JSON
    var parameters: Parameters? { get }
    /// Data added to HTTP request body. Ignore `parameters` if `body` is not nil
    var body: Data? { get }
    /// Define custom value of `Accept` HTTP request header parameter instead of default value
    var acceptType: HTTPContentType? { get }
    /// Define custom value of `Content-Type` HTTP request header parameter instead of default value
    var contentType: HTTPContentType? { get }
    /// Collection of properties (`[key:value]`) which should be added to URL string as parameters
    var query: Query? { get }
    /// Indicate if authentication (session) token should be added to `URLRequest`
    var authorized: Bool {get}
}

extension API {
    
    func request(endpoint: APIEndpoint) throws -> URLRequestConvertible {
        var url = baseURL
        
        // Query
        if let query = endpoint.query, var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            var queryItems = components.queryItems ?? [URLQueryItem]()
            queryItems.append(contentsOf: query.map { element in URLQueryItem(name: element.key, value: element.value) } )
            components.queryItems = queryItems
            url = components.url!
        }
        
        var urlRequest = try URLRequest(url: endpoint.path.path.isEmpty ? url : url.appendingPathComponent(endpoint.path.path), method: endpoint.method)
        
        // Common Headers
        
        
        
        urlRequest.setValue((endpoint.acceptType ?? defaultAcceptType).rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue((endpoint.contentType ?? defaultContentType).rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let body = endpoint.body {
            urlRequest.httpBody = body
        } else if let parameters = endpoint.parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
    
}
