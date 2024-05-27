//
//  URLRequest+curl.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

extension URLRequest {
    
    /// Request as a string, which can be used with `curl` utility
    var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = "curl \(url.absoluteString)"
        
        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }
        
        var command = [baseCommand]
        
        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }
        
        if let data = httpBody {
            // TODO: Hide all passwords from logs if used
            /*
            if var parameters = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                var hasChanges = false
                for key in ServerAPI.Parameters.passParameters {
                    if let _ = parameters[key] as? String {
                        parameters[key] = "***"
                        hasChanges = true
                    }
                }
                if hasChanges, let newData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                    data = newData
                }
            }
             */
            if let body = String(data: data, encoding: .utf8) {
                command.append("-d '\(body)'")
            }
        }
        
        return command.joined(separator: " \\\n\t")
    }
}
