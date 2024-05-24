//
//  AppDelegateServiceContract.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation
import Swinject

typealias Resolver = Swinject.Resolver

protocol AppDelegateServiceProtocol {
    var dependenciesResolver: Resolver {get}
}
