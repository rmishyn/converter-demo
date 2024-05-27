//
//  CurrenciesRepositoryImpl.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

final class CurrenciesRepositoryImpl: CurrenciesRepository {
    
    private let appConfiguration: AppConfiguration
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }
    
    func fetchCurrencies() async -> [Currency] {
        appConfiguration.supportedCurrencies.map({ Currency(id: $0) })
    }
}
