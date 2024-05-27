//
//  NetworkingRequesting.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation
import Alamofire

/// Protocol used to describe services ability to perform API requests
protocol NetworkingRequesting {
    
    /// Service which provides interaction with remote server
    var core: NetworkingService {get}
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return request execution result (success or failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping VoidResultClosure)
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return raw response data or error description (if request or parsing failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DataResultClosure)
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return response data parsed into dictionary or error description (if request or parsing failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DictResultClosure)
    
    /// Perform URL request
    /// - Parameters:
    ///     - request: A data item which can be represented as URL request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called after request is performed. Used to return response data parsed into array or error description (if request or parsing failed)
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping ArrResultClosure)
}

extension NetworkingRequesting where Self: NetworkingResponseProcessing {
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping VoidResultClosure) {
        core.performRequest(request) { [weak self] (result: Result<Data,Error>, _) in
            self?.processDataResponseToVoid(result: result, logLabel: logLabel, completion: completion)
        }
    }
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DataResultClosure) {
        core.performRequest(request) { (result: Result<Data,Error>, _) in
            completion(result)
        }
    }
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping DictResultClosure) {
        core.performRequest(request) { [weak self] (result: Result<Data,Error>, _) in
            self?.processDataResponseToDict(result: result, logLabel: logLabel, completion: completion)
        }
    }
    
    func performRequest(_ request: URLRequestConvertible, logLabel: String, completion:  @escaping ArrResultClosure) {
        core.performRequest(request) { [weak self] (result: Result<Data,Error>, _) in
            self?.processDataResponseToArr(result: result, logLabel: logLabel, completion: completion)
        }
    }
}
