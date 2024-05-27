//
//  ConversionRepositoryImpl.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import Foundation

class ConversionRepositoryImpl: ConversionRepository {
    
    private let financeAPIService: FinanceAPIService
    
    init(financeAPIService: FinanceAPIService) {
        self.financeAPIService = financeAPIService
    }
    
    func getConvertedAmount(for currencyToConvert: String,
                            amountToConvert: Double,
                            currencyToReceive: String) async throws -> CurrencyAmount {
        try await financeAPIService.getConvertedAmount(for: currencyToConvert, amountToConvert: amountToConvert, currencyToReceive: currencyToReceive)
    }
}
