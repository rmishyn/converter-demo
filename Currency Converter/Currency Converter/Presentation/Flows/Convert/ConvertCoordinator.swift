//
//  ConvertCoordinator.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 24.05.2024.
//

import Foundation

protocol ConvertCoordinatorOutput: AnyObject {
    
}

class ConvertCoordinator: AbstractCoordinator, Coordinator, ChildCoordinatorFinishing {
    
    enum Destination {
        case converter
    }
    
    // MARK: Properties
    
    private(set) weak var output: ConvertCoordinatorOutput?
    
    // MARK: Lifecycle
    
    init(configuration: CoordinatorConfiguration<ConvertCoordinatorOutput>, dependenciesResolver: Resolver) {
        self.output = configuration.output
        super.init(navigationController: configuration.navigationController, dependenciesResolver: dependenciesResolver)
    }
    
    deinit {
        
    }
    
    // MARK: Coordinator
    
    func start() {
        start(destination: .converter)
    }
    
    func start(destination: ConvertCoordinator.Destination) {
        switch destination {
        case .converter:
            setConverter()
        }
    }
}

// MARK: - Private methods

private extension ConvertCoordinator {
    
    func setConverter() {
        let configuration = ConverterConfiguration()
        let viewController = ConverterBuilder().build(output: self, configuration: configuration)
        setToNavigationController(viewController: viewController, animated: false, completion: nil)
    }
}

// MARK: - ConverterOutput

extension ConvertCoordinator: ConverterOutput {
    
}
