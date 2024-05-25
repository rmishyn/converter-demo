//
//  UILabel+Styling.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 25.05.2024.
//

import UIKit

// MARK: - Stylable

extension UILabel {
    
    enum UIStyle {
        case itemTitle
        case explanation
    }
    
    typealias Style = UILabel.UIStyle
    
    @discardableResult
    func applyStyle(_ style: Style) -> Self {
        switch style {
        case .itemTitle:
            self.textColor = .label
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        case .explanation:
            self.textColor = .tertiaryLabel
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize * 0.75, weight: .regular)
        }
        return self
    }
}
