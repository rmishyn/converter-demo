//
//  NetworkingServiceImpl.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation
import Alamofire

/// Service which provides interaction with remote server
class NetworkingServiceImpl: NetworkingService {
    
    // MARK: ServerService
    
    func processResponse<T>(_ responseData: AFDataResponse<Data>, authenticated: Bool, completion: ServerResponseCompletion<T>?) {
        
        var result: Result<T,Error>
        var completion = completion
        defer {
            completion?(result, responseData)
        }
        
        if let response = responseData.response {
            switch responseData.result {
            case .success(let data): // status code is auto-validated in 'performRequest' by using 'validate()'
                guard let data = responseData.data as? T else { return result = .failure(CCError.invalidResponseDataType) }
                if T.self == Data.self {
                    print("response: \(String(describing: String(data: data as! Data, encoding: .utf8)))")
                } else {
                    print("response: \(data)")
                }
                return result = .success(data)
            case .failure(let error):
                if authenticated, response.statusCode == HTTPStatusCode.unauthorized.rawValue {
                    print("response (unauthorized): code=\(response.statusCode) / url=\(String(describing: response.url))")
                    completion = nil
                    result = .failure(error)
                    if let data = responseData.data,
                        let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        print("\tdetails: \(jsonDict)")
                    } else {
                        print("\tno details")
                    }
                    handleUnauthorized(error: error)
                    return
                }
            }
        }
        
        print("response (failed): code=\(String(describing: responseData.response?.statusCode)) / url=\(String(describing: responseData.response?.url))")
        var details: String?
        if let data = responseData.data {
            print("\t\(String(describing: String(data: data, encoding: .utf8)))")
            details = String(data: data, encoding: .utf8)
        }
        result = .failure(CCError.unknown(domain: .networking,
                                          statusCode: responseData.response?.statusCode ?? 0,
                                          details: details))
    }
    
    func performRequest<T>(_ request: URLRequestConvertible, completion: ServerResponseCompletion<T>?) {
        print("Try to send request: \(request)")
        guard let request = try? request.asURLRequest() else {
            assertionFailure("Cannot convert 'URLRequestConvertible' to 'URLRequest'")
            return
        }
        // Add request customization here if needed - like authentication token, additional keys to header, etc.
        print("Send request:\n\(request.curlString)")
        AF.request(request).validate().responseData(completionHandler: { [weak self] (responseData) in
            print("response received")
            guard let self = self else { return }
            print("process response")
            self.processResponse(responseData, authenticated: false, completion: completion)
        })
    }
    
    func handleUnauthorized(error: Error) {
        // TODO: Place where to start re-authorization
    }
}
