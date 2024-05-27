//
//  GetConvertedValue.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 26.05.2024.
//

import Foundation

protocol GetConvertedValue {
    func getConvertedValue(requestValue: GetConvertedValueRequestValue) async -> GetConvertedValueResponseValue
}

struct GetConvertedValueRequestValue: Equatable {
    let currencyToConvert: Currency
    let valueToConvert: Double
    let currencyToReceive: Currency
}

struct GetConvertedValueResponseValue {
    let request: GetConvertedValueRequestValue
    let result: Result<CurrencyAmount, Error>
}

final class GetConvertedValueUseCase: GetConvertedValue {
    
    private let repository: ConversionRepository
    
    init(repository: ConversionRepository) {
        self.repository = repository
    }
    
    func getConvertedValue(requestValue: GetConvertedValueRequestValue) async -> GetConvertedValueResponseValue {
        do {
            let res = try await repository.getConvertedAmount(for: requestValue.currencyToConvert.id,
                                                              amountToConvert: requestValue.valueToConvert,
                                                              currencyToReceive: requestValue.currencyToReceive.id)
            return GetConvertedValueResponseValue(request: requestValue, result: .success(res))
        } catch {
            return GetConvertedValueResponseValue(request: requestValue, result: .failure(error))
        }
    }
}
