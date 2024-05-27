//
//  CurrenciesRepository.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import Foundation

protocol CurrenciesRepository {
    func fetchCurrencies() async -> [Currency]
}
