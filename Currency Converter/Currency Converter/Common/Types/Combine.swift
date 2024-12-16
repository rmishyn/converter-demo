//
//  Combine.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 16.12.2024.
//

import Combine

typealias CancelBag = Set<AnyCancellable>
typealias AnyRelay<Output> = AnyPublisher<Output, Never>
