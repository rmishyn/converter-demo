//
//  UIDevice+Extension.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 28.05.2024.
//

import UIKit

extension UIDevice {
    var isIPad: Bool {
        userInterfaceIdiom == .pad
    }
}
