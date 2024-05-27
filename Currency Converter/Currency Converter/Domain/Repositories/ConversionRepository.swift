//
//  ConversionRepository.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import Foundation

protocol ConversionRepository {
    func getConvertedAmount(for currencyToConvert: String, 
                            amountToConvert: Double,
                            currencyToReceive: String) async throws -> CurrencyAmount
}
