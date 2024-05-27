//
//  NetworkingResponseProcessing.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

/// Protocol used to describe ability to parse received remote data of `Response<Data>` format into acceptible data format
protocol NetworkingResponseProcessing: AnyObject {
    /// Process response into `success` or `failure` state
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToVoid(result: Result<Data,Error>, logLabel: String, completion: @escaping VoidResultClosure)
    /// Process response into `success` or `failure` state. If processing result is `success` then it must contain a dictionary of parsed values
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToDict(result: Result<Data,Error>, logLabel: String, completion: @escaping DictResultClosure)
    /// Process response into `success` or `failure` state. If processing result is `success` then it must contain an array of parsed values
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToArr(result: Result<Data,Error>, logLabel: String, completion: @escaping ArrResultClosure)
    /// Process response into `success` or `failure` state. If processing result is `success` then it must contain a parsed value as string
    /// - Parameters:
    ///     - result: Property containint result of request
    ///     - logLabel: String used to customize logging related to this request
    ///     - completion: Closure called to provide results of response processing
    func processDataResponseToString(result: Result<Data,Error>, logLabel: String, completion: @escaping StringResultClosure)
}

extension NetworkingResponseProcessing {
    
    func processDataResponseToVoid(result: Result<Data,Error>, logLabel: String, completion: @escaping VoidResultClosure) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success:
                print("RESPONSE: \(logLabel) - success")
                completion(.success(()))
            case .failure(let error):
                print("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
    
    func processDataResponseToArr(result: Result<Data,Error>, logLabel: String, completion: @escaping ArrResultClosure) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                print("RESPONSE: \(logLabel) - success")
                do {
                    let arr = try NetworkingServiceHelper.parseArr(data: data)
                    completion(.success(arr))
                } catch {
                    print("RESPONSE: \(logLabel) - Parse failure: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
    
    func processDataResponseToDict(result: Result<Data,Error>, logLabel: String, completion: @escaping DictResultClosure) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                print("RESPONSE: \(logLabel) - success")
                do {
                    let dict = try NetworkingServiceHelper.parseDict(data: data)
                    completion(.success(dict))
                } catch {
                    print("RESPONSE: \(logLabel) - Parse failure: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
    
    func processDataResponseToString(result: Result<Data,Error>, logLabel: String, completion: @escaping StringResultClosure) {
        DispatchQueue.global().async { [weak self] in
            guard let _ = self else { return }
            switch result {
            case .success(let data):
                print("RESPONSE: \(logLabel) - success")
                guard let str = String(data: data, encoding: .utf8) else {
                    print("RESPONSE: \(logLabel) - Data to string conversion failure")
                    let error = CCError.formatConversionFailed
                    completion(.failure(error))
                    return
                }
                completion(.success(str))
            case .failure(let error):
                print("RESPONSE: \(logLabel) - failed")
                completion(.failure(error))
            }
        }
    }
    
}
