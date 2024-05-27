//
//  Stylable.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 25.05.2024.
//

import Foundation

protocol Stylable {
    associatedtype Style
    func applyStyle(_ style: Style) -> Self
}
