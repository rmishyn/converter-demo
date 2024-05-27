//
//  GetSupportedCurrencies.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

protocol GetSupportedCurrencies {
    func getSupportedCurrencies() async -> [Currency]
}

final class GetSupportedCurrenciesUseCase: GetSupportedCurrencies {
    
    private let repository: CurrenciesRepository
    
    init(repository: CurrenciesRepository) {
        self.repository = repository
    }
    
    func getSupportedCurrencies() async -> [Currency] {
        await repository.fetchCurrencies()
    }
}
