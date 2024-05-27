//
//  String+Extension.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 24.05.2024.
//

import Foundation

extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
    
    var intValue: Int? { Int(self) }
    
    var doubleValue: Double? { Double(self) }
}
