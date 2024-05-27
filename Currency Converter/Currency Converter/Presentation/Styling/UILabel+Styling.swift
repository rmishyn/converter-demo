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
        case errorTitle
        case errorDetails
    }
    
    typealias Style = UILabel.UIStyle
    
    @discardableResult
    func applyStyle(_ style: Style) -> Self {
        switch style {
        case .itemTitle:
            self.textColor = .label
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        case .explanation:
            self.textColor = .secondaryLabel
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize * 0.75, weight: .regular)
            self.numberOfLines = 0
        case .errorTitle:
            self.textColor = .red
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize, weight: .regular)
        case .errorDetails:
            self.textColor = .red
            self.font = UIFont.systemFont(ofSize: UIFont.labelFontSize * 0.75, weight: .regular)
            self.numberOfLines = 0
        }
        return self
    }
}
