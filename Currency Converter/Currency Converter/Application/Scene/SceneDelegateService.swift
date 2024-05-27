//
//  SceneDelegateService.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 23.05.2024.
//

import UIKit
import Swinject

class SceneDelegateService: SceneDelegateServiceProtocol {
    
    // MARK: Properties
    
    private var window: UIWindow
    private var dependenciesResolver: Resolver
    
    private var sceneCoordinator: SceneCoordinator!
    
    // MARK: Lifecycle
    
    init(window: UIWindow,
         dependenciesResolver: Resolver) {
        self.window = window
        self.dependenciesResolver = dependenciesResolver
        setup()
    }
}

// MARK: - Private methods

private extension SceneDelegateService {
    
    func setup() {
        Task {
            await setupSceneCoordinator()
        }
    }
    
    @MainActor
    func setupSceneCoordinator() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.accent
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        
        window.rootViewController = navigationController
        
        let coordinatorConfiguration = CoordinatorConfiguration<SceneCoordinatorOutput>(navigationController: navigationController, output: self)
        let sceneCoordinator = SceneCoordinator(configuration: coordinatorConfiguration,
                                                dependenciesResolver: dependenciesResolver)
        sceneCoordinator.start()
    }
}

// MARK: - SceneCoordinatorOutput

extension SceneDelegateService: SceneCoordinatorOutput { }
