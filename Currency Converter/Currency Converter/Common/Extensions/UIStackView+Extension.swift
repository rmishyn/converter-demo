//
//  UIStackView+Extension.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 25.05.2024.
//

import UIKit

extension UIStackView {
    
    convenience init(axis: NSLayoutConstraint.Axis, spacing: CGFloat?) {
        self.init()
        self.axis = axis
        if let spacing = spacing {
            self.spacing = spacing
        }
    }
}
