//
//  FinanceAPIServiceImpl.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 27.05.2024.
//

import Foundation

class FinanceAPIServiceImpl: FinanceAPIService {
    
    private let financeAPI: FinanceAPI
    private let networkingService: NetworkingService
    
    init(financeAPI: FinanceAPI, networkingService: NetworkingService) {
        self.financeAPI = financeAPI
        self.networkingService = networkingService
    }
    
    func getConvertedAmount(for currencyToConvert: String,
                            amountToConvert: Double,
                            currencyToReceive: String) async throws -> CurrencyAmountDTO {
        
        let endpoint = financeAPI.exchangeEndpoint(fromAmount: amountToConvert, fromCurrency: currencyToConvert, toCurrency: currencyToReceive)
        do {
            let request = try financeAPI.request(endpoint: endpoint)
            let result = try await withCheckedThrowingContinuation { [weak self] continuation in
                guard let self = self else { return }
                let completion: ServerResponseCompletion<Data> = { (result,data) in
                    switch result {
                    case .success(let data):
                        do {
                            let currencyAmount = try JSONDecoder().decode(CurrencyAmountDTO.self, from: data)
                            continuation.resume(returning: currencyAmount)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
                self.networkingService.performRequest(request, completion: completion)
            }
            return result
        } catch {
            throw error
        }
    }
}
