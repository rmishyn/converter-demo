//
//  NetworkingService.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation
import Alamofire

typealias ServerResponseCompletion<T> = (Result<T,Error>, AFDataResponse<Data>?) -> Void

/// Protocol describing requirements to service which provides interaction with remote server using URL request
protocol NetworkingService {
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - completion: Closure called after request is performed. Used to return response data or error description (if request failed)
    func performRequest<T>(_ request: URLRequestConvertible, completion: ServerResponseCompletion<T>?)
}
