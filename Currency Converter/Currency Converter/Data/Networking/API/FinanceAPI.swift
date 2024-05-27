//
//  FinanceAPI.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import Foundation
import Alamofire

protocol FinanceAPI: API { 
    func exchangeEndpoint(fromAmount: Double, fromCurrency: String, toCurrency: String) -> APIEndpoint
}

final class FinanceAPIImpl: FinanceAPI {
    
    // MARK: - Enumerataions
    
    // MARK: Path
    
    enum Path: APIPath {
        
        case exchange(fromAmount: Double, fromCurrency: String, toCurrency: String)
        
        var path: String {
            switch self {
            case .exchange(let fromAmount, let fromCurrency, let toCurrency):
                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 2
                let from = [formatter.string(from: NSNumber(floatLiteral: fromAmount))!, fromCurrency].joined(separator: "-")
                return ["currency", "commercial", "exchange", from, toCurrency, "latest"].joined(separator: "/")
            }
        }
    }
    
    // MARK: Endpoint
    
    enum Endpoint: APIEndpoint {
        
        case exchange(fromAmount: Double, fromCurrency: String, toCurrency: String)
        
        /// Endpoint relative path (to base url)
        var path: APIPath {
            switch self {
            case .exchange(let fromAmount, let fromCurrency, let toCurrency): Path.exchange(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
            }
        }
        
        /// HTTP method of request
        var method: HTTPMethod {
            switch self {
            case .exchange: .get
            }
        }
        
        /// Body parameters - to be serialized as JSON
        var parameters: Parameters? { nil }
        
        /// Data added to HTTP request body. Ignore `parameters` if `body` is not nil
        var body: Data? { nil }
        
        /// Define custom value of `Accept` HTTP request header parameter instead of default value
        var acceptType: HTTPContentType? { nil }
        
        /// Define custom value of `Content-Type` HTTP request header parameter instead of default value
        var contentType: HTTPContentType? { nil }
        
        /// Collection of properties (`[key:value]`) which should be added to URL string as parameters
        var query: Query? { nil }
        
        /// Indicate if authentication (session) token should be added to `URLRequest`
        var authorized: Bool { false }
    }
    
    // MARK: - Properties
    
    private let appConfiguration: AppConfiguration
    var baseURL: URL { appConfiguration.apiBaseURL }
    var defaultAcceptType: HTTPContentType { appConfiguration.defaultAcceptType }
    var defaultContentType: HTTPContentType { appConfiguration.defaultContentType }
    
    // MARK: - Lifecycle
    
    init(appConfiguration: any AppConfiguration) {
        self.appConfiguration = appConfiguration
    }
    
    // MARK: - FinanceAPI
    
    func exchangeEndpoint(fromAmount: Double, fromCurrency: String, toCurrency: String) -> APIEndpoint {
        FinanceAPIImpl.Endpoint.exchange(fromAmount: fromAmount, fromCurrency: fromCurrency, toCurrency: toCurrency)
    }
}
