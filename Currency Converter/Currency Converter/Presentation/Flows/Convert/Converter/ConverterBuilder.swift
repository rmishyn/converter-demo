//
//  ConverterBuilder.swift
//  currency converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation

struct ConverterConfiguration {
    
}

struct ConverterBuilder {
    
    typealias BuilderConfiguration = ConverterConfiguration
    typealias BuilderOutput = ConverterOutput
    typealias BuilderViewController = ConverterViewController
    typealias BuilderViewModel = ConverterViewModel
    
    func build(output: BuilderOutput, configuration: BuilderConfiguration) -> BuilderViewController {
        let viewModel = BuilderViewModel(output: output, configuration: configuration)
        let viewController = BuilderViewController(viewModel: viewModel)
        return viewController
    }
}
