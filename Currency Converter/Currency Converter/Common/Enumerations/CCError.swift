//
//  DataTransferError.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

/// List of error domains
enum ErrorDomain: String {
    case networking = "Networking"
}

enum CCError: Error {
    case invalidResponseDataType
    case formatConversionFailed
    case unknown(domain: ErrorDomain, statusCode: Int, details: String?)
    
    var details: String {
        switch self {
        case .invalidResponseDataType: "Response uses unexpected format"
        case .formatConversionFailed: "Format conversion failed"
        case .unknown(domain: let domain, statusCode: let code, details: let details): "Unknown (domain=\(domain.rawValue), code=\(code), details: \(details ?? "")"
        }
    }
}
