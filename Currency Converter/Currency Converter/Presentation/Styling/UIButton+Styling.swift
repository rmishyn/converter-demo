//
//  UIButton+Styling.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 25.05.2024.
//

import UIKit

// MARK: - Stylable

extension UIButton {
    
    enum UIStyle {
        case selectCurrency
    }
    
    typealias Style = UIButton.UIStyle
    
    @discardableResult
    func applyStyle(_ style: Style) -> Self {
        switch style {
        case .selectCurrency:
            self.backgroundColor = .lightGray
            self.setTitleColor(.tintColor, for: .normal)
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize, weight: .bold)
            self.layer.borderColor = UIColor.tintColor.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 3
        }
        return self
    }
}
