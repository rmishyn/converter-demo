//
//  ConverterContract.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation

typealias ConverterViewModelProtocol = ConverterViewModelInput & ConverterViewModelOutput

protocol ConverterViewModelInput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didChangeOriginalValue(to value: Double)
    func shouldChangeFromCurrency()
    func shouldChangeToCurrency()
}

protocol ConverterViewModelOutput: AnyObject {
    var screenTitle: String { get }
    var errorTitle: String { get }
    var fromCurrencyTitle: String { get }
    var toCurrencyTitle: String { get }
    var valueToConvertPlaceholder: String { get }
    var notes: String { get }
    var fromCurrency: Observable<Currency?> {get}
    var toCurrency: Observable<Currency?> {get}
    var convertedValue: Observable<String?> {get}
    var error: Observable<Error?> {get}
}

protocol ConverterOutput: AnyObject {
    
}
