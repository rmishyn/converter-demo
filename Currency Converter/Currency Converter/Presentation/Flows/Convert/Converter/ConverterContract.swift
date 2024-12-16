//
//  ConverterContract.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Combine
import Foundation

typealias ConverterViewModelProtocol = ConverterViewModelInput & ConverterViewModelOutput

protocol ConverterViewModelInput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didChangeOriginalValue(to value: Double)
    func didChangeFromCurrency(to currency: Currency)
    func didChangeToCurrency(to currency: Currency)
}

protocol ConverterViewModelOutput: AnyObject {
    var screenTitle: String { get }
    var errorTitle: String { get }
    var fromCurrencyTitle: String { get }
    var toCurrencyTitle: String { get }
    var valueToConvertPlaceholder: String { get }
    var notes: String { get }
    
    var fromCurrency: Currency? { get }
    var fromCurrencyPublisher: AnyRelay<Currency?> { get }
    var toCurrency: Currency? { get }
    var toCurrencyPublisher: AnyRelay<Currency?> { get }
    var convertedValuePublisher: AnyRelay<String?> { get }
    var errorPublisher: AnyRelay<Error?> { get }
    var supportedCurrencies: [Currency] { get }
    var supportedCurrenciesPublisher: AnyRelay<[Currency]> { get }
    var isConversionActivePublisher: AnyRelay<Bool> { get }
}

protocol ConverterOutput: AnyObject {
    
}
