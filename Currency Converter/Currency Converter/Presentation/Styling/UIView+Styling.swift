//
//  UIView+Styling.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 25.05.2024.
//

import UIKit

// MARK: - Stylable

extension UIView: Stylable {
    
    enum UIStyle {
        case transparent
        case screenView
        case underline
    }
    
    typealias Style = UIView.UIStyle
    
    @discardableResult
    func applyStyle(_ style: Style) -> Self {
        switch style {
        case .transparent:
            self.backgroundColor = .clear
        case .screenView:
            self.backgroundColor = .screenBackground
        case .underline:
            self.backgroundColor = .label
        }
        return self
    }
}
