//
//  FinanceAPIService.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

protocol FinanceAPIService {
    func getConvertedAmount(for currencyToConvert: String,
                            amountToConvert: Double,
                            currencyToReceive: String) async throws -> CurrencyAmountDTO
}
