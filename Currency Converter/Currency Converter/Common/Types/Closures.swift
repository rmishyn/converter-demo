//
//  Closures.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 24.05.2024.
//

import Foundation

typealias VoidClosure = () -> ()
typealias DoubleClosure = (Double) -> ()
typealias VoidResultClosure = (Result<Void,Error>) -> ()
typealias DataResultClosure = (Result<Data,Error>) -> ()
typealias StringResultClosure = (Result<String,Error>) -> ()
typealias ArrResultClosure = (Result<[Any],Error>) -> ()
typealias DictResultClosure = (Result<[String:Any],Error>) -> ()
