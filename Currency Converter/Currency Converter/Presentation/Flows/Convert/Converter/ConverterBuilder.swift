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
//    typealias BuilderPresenter = AccountPresenter
//    
    func build(output: BuilderOutput, configuration: BuilderConfiguration) -> BuilderViewController {
        
        ConverterViewController()
        
//        let viewController = BuilderViewController.controllerFromStoryboard(storyboard)
//        let presenter = BuilderPresenter(view: viewController, output: output, configuration: configuration)
//        viewController.presenter = presenter
//        return viewController
    }
}
