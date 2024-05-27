//
//  AppConfiguration.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation

protocol AppConfiguration {
    var apiBaseURL: URL {get}
    var defaultAcceptType: HTTPContentType {get}
    var defaultContentType: HTTPContentType {get}
}
