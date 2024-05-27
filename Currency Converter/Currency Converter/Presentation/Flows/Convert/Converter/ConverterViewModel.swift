//
//  ConverterViewModel.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation

class ConverterViewModel: ConverterViewModelProtocol {
    
    // MARK: Constants
    
    private struct Constants {
        static let delayedRequestTimeInterval: TimeInterval = 1
        static let repetitiveRequestTimeInterval: TimeInterval = 10
    }
    
    // MARK: Properties
    
    private let output: ConverterOutput
    private var lastValueToConvert: Double? {
        didSet {
            guard lastValueToConvert != oldValue else { return }
            updateConversionResult()
        }
    }
    private var delayedRequestTimer: Timer?
    
    // MARK: UseCases
    
    private let getExchangedAmountUseCase: GetConvertedValue
    private let getSupportedCurrenciesUseCase: GetSupportedCurrencies
    
    // MARK: ConverterViewModelOutput
    
    let screenTitle = "Converter".localized
    let errorTitle = "Error".localized
    let fromCurrencyTitle = "You are sending:".localized
    let toCurrencyTitle = "You will receive:".localized
    let valueToConvertPlaceholder = "Enter value".localized
    let notes = "exchange notes".localized
    var fromCurrency: Observable<Currency?> = Observable(nil)
    var toCurrency: Observable<Currency?> = Observable(nil)
    var convertedValue: Observable<String?> = Observable(nil)
    var error: Observable<Error?> = Observable(nil)
    var supportedCurrencies: Observable<[Currency]> = Observable([])
    var isConversionActive: Observable<Bool> = Observable(false)
    
    // MARK: Lifecycle
    
    init(output: ConverterOutput, configuration: ConverterConfiguration) {
        self.output = output
        self.getExchangedAmountUseCase = configuration.getConvertedValueUseCase
        self.getSupportedCurrenciesUseCase = configuration.getSupportedCurrenciesUseCase
    }
}

// MARK: - ConverterViewModelInput

extension ConverterViewModel {
    
    func viewDidLoad() {
        Task {
            self.supportedCurrencies.value = await getSupportedCurrenciesUseCase.getSupportedCurrencies()
        }
        #if DEBUG
        lastValueToConvert = 1000
        #endif
    }
    
    func viewWillAppear() {
        updateConversionResult(delayInterval: 0)
    }
    
    func viewWillDisappear() {
        delayedRequestTimer?.invalidate()
    }
    
    func didChangeOriginalValue(to value: Double) {
        self.lastValueToConvert = value
    }
    
    func didChangeFromCurrency(to currency: Currency) {
        fromCurrency.value = currency
        updateConversionResult()
    }
    
    func didChangeToCurrency(to currency: Currency) {
        toCurrency.value = currency
        updateConversionResult()
    }
}

// MARK: - Private methods

private extension ConverterViewModel {
    
    func updateConversionResult(delayInterval: TimeInterval = ConverterViewModel.Constants.delayedRequestTimeInterval) {
        delayedRequestTimer?.invalidate()
        self.delayedRequestTimer = Timer.scheduledTimer(withTimeInterval: delayInterval, repeats: false) { [weak self] _ in
            self?.updateConversionResultDelayed()
        }
    }
    
    func updateConversionResultDelayed() {
        guard let fromCurrency = fromCurrency.value, let toCurrency = toCurrency.value, fromCurrency != toCurrency else {
            convertedValue.value = nil
            return
        }
        guard let amountToConvert = lastValueToConvert else {
            convertedValue.value = "0"
            return
        }
        isConversionActive.value = true
        Task {
            let requestValue = GetConvertedValueRequestValue(currencyToConvert: fromCurrency, valueToConvert: amountToConvert, currencyToReceive: toCurrency)
            let response = await getExchangedAmountUseCase.getConvertedValue(requestValue: requestValue)
            guard response.request == requestValue else { return }
            await handleConvertedValueResponse(response.result)
        }
    }
    
    @MainActor
    func handleConvertedValueResponse(_ response: Result<CurrencyAmount, Error>) {
        defer {
            isConversionActive.value = false
        }
        switch response {
        case .success(let currencyAmount):
            self.convertedValue.value = currencyAmount.amount
            self.error.value = nil
        case .failure(let error):
            self.convertedValue.value = nil
            self.error.value = error
        }
        updateConversionResult(delayInterval: ConverterViewModel.Constants.repetitiveRequestTimeInterval)
    }
}
