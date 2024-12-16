//
//  ConverterViewModel.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Combine
import Foundation

class ConverterViewModel: ConverterViewModelProtocol {
    
    // MARK: Constants
    
    private struct Constants {
        static let delayedRequestTimeInterval: TimeInterval = 0.5
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
    
    @Published private var convertedValue: String?
    @Published private var error: Error?
    @Published private var isConversionActive: Bool = false
    
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
    
    @Published private(set) var fromCurrency: Currency? {
        didSet { updateConversionResult() }
    }
    @Published private(set) var toCurrency: Currency? {
        didSet { updateConversionResult() }
    }
    @Published private(set) var supportedCurrencies: [Currency] = []
    
    // MARK: Lifecycle
    
    init(output: ConverterOutput, configuration: ConverterConfiguration) {
        self.output = output
        self.getExchangedAmountUseCase = configuration.getConvertedValueUseCase
        self.getSupportedCurrenciesUseCase = configuration.getSupportedCurrenciesUseCase
    }
}

// MARK: - ConverterViewModelOutput

extension ConverterViewModel {
    
    var fromCurrencyPublisher: AnyRelay<Currency?> { $fromCurrency.eraseToAnyPublisher() }
    var toCurrencyPublisher: AnyRelay<Currency?> { $toCurrency.eraseToAnyPublisher() }
    var convertedValuePublisher: AnyRelay<String?> { $convertedValue.eraseToAnyPublisher() }
    var errorPublisher: AnyRelay<Error?> { $error.eraseToAnyPublisher() }
    var supportedCurrenciesPublisher: AnyRelay<[Currency]> { $supportedCurrencies.eraseToAnyPublisher() }
    var isConversionActivePublisher: AnyRelay<Bool> { $isConversionActive.eraseToAnyPublisher() }
}

// MARK: - ConverterViewModelInput

extension ConverterViewModel {
    
    func viewDidLoad() {
        Task {
            self.supportedCurrencies = await getSupportedCurrenciesUseCase.getSupportedCurrencies()
        }
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
        fromCurrency = currency
    }
    
    func didChangeToCurrency(to currency: Currency) {
        toCurrency = currency
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
        guard let fromCurrency, let toCurrency = toCurrency, fromCurrency != toCurrency else {
            convertedValue = nil
            return
        }
        guard let amountToConvert = lastValueToConvert else {
            convertedValue = "0"
            return
        }
        isConversionActive = true
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
            isConversionActive = false
        }
        switch response {
        case .success(let currencyAmount):
            self.convertedValue = currencyAmount.amount
            self.error = nil
        case .failure(let error):
            self.convertedValue = nil
            self.error = error
        }
        updateConversionResult(delayInterval: ConverterViewModel.Constants.repetitiveRequestTimeInterval)
    }
}
