//
//  AppConfigurationImpl.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation

final class AppConfigurationImpl: AppConfiguration {
    let apiBaseURL = URL(string: "http://api.evp.lt")!
    let defaultAcceptType = HTTPContentType.json
    let defaultContentType = HTTPContentType.json
}
