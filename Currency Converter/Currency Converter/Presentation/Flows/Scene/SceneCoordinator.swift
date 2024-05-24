//
//  SceneCoordinator.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 24.05.2024.
//

import Foundation

protocol SceneCoordinatorOutput: AnyObject {
    
}

class SceneCoordinator: AbstractCoordinator, Coordinator, ChildCoordinatorFinishing {
    
    enum Destination {
        case converter
    }
    
    // MARK: Properties
    
    private(set) weak var output: SceneCoordinatorOutput?
    
    // MARK: Lifecycle
    
    init(configuration: CoordinatorConfiguration<SceneCoordinatorOutput>, dependenciesResolver: Resolver) {
        self.output = configuration.output
        super.init(navigationController: configuration.navigationController, dependenciesResolver: dependenciesResolver)
    }
    
    deinit {
        
    }
    
    // MARK: Coordinator
    
    func start() {
        start(destination: .converter)
    }
    
    func start(destination: SceneCoordinator.Destination) {
        switch destination {
        case .converter:
            setConverter()
        }
    }
}

// MARK: - Private methods

private extension SceneCoordinator {
    
    func setConverter() {
        let configuration = CoordinatorConfiguration<ConvertCoordinatorOutput>(navigationController: navigationController, output: self)
        let coordinator = ConvertCoordinator(configuration: configuration, dependenciesResolver: dependenciesResolver)
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

// MARK: - ConvertCoordinatorOutput

extension SceneCoordinator: ConvertCoordinatorOutput {
    
}
