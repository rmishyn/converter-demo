//
//  AppDelegateService.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import Foundation
import Swinject

class AppDelegateService: AppDelegateServiceProtocol {
    
    // MARK: Properties
    
    
    private var diContainer: Container!
    var dependenciesResolver: Resolver { diContainer }
    
    // MARK: Lifecycle
    
    init() {
        setup()
    }
}

// MARK: - Private methods

private extension AppDelegateService {
    
    func setup() {
        setupDependencies()
    }
    
    func setupDependencies() {
        let diContainer = Container()
        diContainer.register(AppConfigurationProtocol.self) { _ in AppConfiguration() }
        self.diContainer = diContainer
    }
}
