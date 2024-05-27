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
        diContainer.register(AppConfiguration.self) { _ in
            AppConfigurationImpl()
        }
        diContainer.register(NetworkingService.self) { _ in
            NetworkingServiceImpl()
        }
        diContainer.register(FinanceAPI.self) { resolver in
            FinanceAPIImpl(appConfiguration: resolver.resolve(AppConfiguration.self)!)
        }
        diContainer.register(FinanceAPIService.self) { resolver in
            FinanceAPIServiceImpl(financeAPI: resolver.resolve(FinanceAPI.self)!, networkingService: resolver.resolve(NetworkingService.self)!)
        }
        diContainer.register(ConversionRepository.self) { resolver in
            ConversionRepositoryImpl(financeAPIService: resolver.resolve(FinanceAPIService.self)!)
        }
        diContainer.register(GetConvertedValue.self) { resolver in
            GetConvertedValueUseCase(repository: resolver.resolve(ConversionRepository.self)!)
        }
        self.diContainer = diContainer
    }
}
