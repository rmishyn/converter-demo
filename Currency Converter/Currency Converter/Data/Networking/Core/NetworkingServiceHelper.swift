//
//  NetworkingServiceHelper.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

/// Structure containing some additional functionality for ServerService objects
struct NetworkingServiceHelper {
    
    /// Convert `Data` from API response into JSON string and parse into dictionary
    /// - Parameter data: Data which should be parsed into dictionary
    /// - Returns: Parsed dictionary. Throws an error if cannot parse
    static func parseDict(data: Data) throws -> [String:Any] {
        guard let jsonDict = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            let str = String(data: data, encoding: .utf8)
            print("failed to parse to dict:\n\(String(describing: str))")
            throw CCError.invalidResponseDataType
        }
        print("Parsed: \(jsonDict)")
        return jsonDict
    }
    
    /// Convert `Data` from API response into JSON string and parse into array
    /// - Parameter data: Data which should be parsed into array
    /// - Returns: Parsed array. Throws an error if cannot parse
    static func parseArr(data: Data) throws -> [Any] {
        guard let jsonArr = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [Any] else {
            let str = String(data: data, encoding: .utf8)
            print("failed to parse to arr:\n\(String(describing: str))")
            throw CCError.invalidResponseDataType
        }
        print("Parsed: \(jsonArr)")
        return jsonArr
    }
}
