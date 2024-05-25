//
//  ConverterViewModel.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation

class ConverterViewModel: ConverterViewModelProtocol {
    
    // MARK: Properties
    
    private var output: ConverterOutput
    
    // MARK: ConverterViewModelOutput
    
    let screenTitle = "Converter".localized
    let errorTitle = "Error".localized
    let fromCurrencyTitle = "You are sending:".localized
    let toCurrencyTitle = "You will receive:".localized
    let amountToExchangePlaceholder = "Enter amount".localized
    let notes = "exchange notes".localized
    var fromCurrency: Observable<String?> = Observable(nil)
    var toCurrency: Observable<String?> = Observable(nil)
    var convertedValue: Observable<Double> = Observable(0)
    var error: Observable<Error?> = Observable(nil)
    
    // MARK: Lifecycle
    
    init(output: ConverterOutput, configuration: ConverterConfiguration) {
        self.output = output
    }
}

// MARK: - ConverterViewModelInput

extension ConverterViewModel {
    
    func viewDidLoad() {
        fromCurrency.value = "EUR"
        toCurrency.value = "USD"
    }
    
    func didChangeOriginalValue(to value: Double) {
        
    }
    
    func shouldChangeFromCurrency() {
        
    }
    
    func shouldChangeToCurrency() {
        
    }
}
