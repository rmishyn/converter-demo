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
    private let getExchangedAmountUseCase: GetConvertedValue
    private var delayedRequestTimer: Timer?
    
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
    
    // MARK: Lifecycle
    
    init(output: ConverterOutput, configuration: ConverterConfiguration) {
        self.output = output
        self.getExchangedAmountUseCase = configuration.getConvertedValueUseCase
    }
}

// MARK: - ConverterViewModelInput

extension ConverterViewModel {
    
    func viewDidLoad() {
        #if DEBUG
        fromCurrency.value = Currency(id: "EUR")
        toCurrency.value = Currency(id: "USD")
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
    
    func shouldChangeFromCurrency() {
        
    }
    
    func shouldChangeToCurrency() {
        
    }
}

// MARK: - Private methods

private extension ConverterViewModel {
    
    func updateConversionResult(delayInterval: TimeInterval = ConverterViewModel.Constants.delayedRequestTimeInterval) {
        delayedRequestTimer?.invalidate()
        let timer = Timer.scheduledTimer(withTimeInterval: delayInterval, repeats: false) { [weak self] _ in
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
        Task {
            let requestValue = GetConvertedValueRequestValue(currencyToConvert: fromCurrency, valueToConvert: amountToConvert, currencyToReceive: toCurrency)
            let response = await getExchangedAmountUseCase.getConvertedValue(requestValue: requestValue)
            guard response.request == requestValue else { return }
            await handleConvertedValueResponse(response.result)
        }
    }
    
    @MainActor
    func handleConvertedValueResponse(_ response: Result<CurrencyAmount, Error>) {
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
