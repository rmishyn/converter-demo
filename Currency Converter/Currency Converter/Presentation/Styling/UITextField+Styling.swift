//
//  UITextField+Styling.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import UIKit

// MARK: - Stylable

extension UITextField {
    
    enum UIStyle {
        case numeric
    }
    
    typealias Style = UITextField.UIStyle
    
    @discardableResult
    func applyStyle(_ style: Style) -> Self {
        switch style {
        case .numeric:
            self.keyboardType = .decimalPad
            self.textColor = .label
        }
        return self
    }
}
