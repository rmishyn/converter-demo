//
//  Publisher+Extension.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 16.12.2024.
//

import Combine
import Foundation

extension Publisher {
    
    /// Method is used for `receive(on: DispatchQueue.main)` shortening
    func onMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }
}
