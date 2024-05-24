//
//  Coordinator.swift
//  Currency Converter
//
//  Created by Ruslan Mishyn on 24.05.2024.
//

import UIKit

struct CoordinatorConfiguration<T> {
    let navigationController: UINavigationController
    let output: T?
    
    init(navigationController: UINavigationController, output: T?) {
        self.navigationController = navigationController
        self.output = output
    }
}

/// Protocol describing a scenes coordinator. Coordinators are used to support "MVVM with coordinators" architecture pattern
protocol Coordinator: AnyObject {
    
    associatedtype T
    
    var output: T {get}
    
    /// Collection of coordinators used to support subflows inside single parent flow
    var childCoordinators: [any Coordinator] { get set }
    
    /// Navigation controller used as start point of flow hadled by this coordinator
    var navigationController: UINavigationController { get }
    
    var _pushedViewControllers: [Weak<UIViewController>] {get set}
    var pushedViewControllers: [Weak<UIViewController>] {get}
    
    /// Run coordinator flow
    func start()
    
    /// Add child coordinator to `childCoordinators` collection
    /// - Parameter coordinator: Child coordinator which should be added
    func addChildCoordinator(_ coordinator: any Coordinator)
    
    /// Remove child coordinator from `childCoordinators` collection
    /// - Parameter coordinator: Child coordinator which should be removed
    func removeChildCoordinator(_ coordinator: any Coordinator)
    
    ///
    func setToNavigationController(viewController: UIViewController?, animated: Bool, completion: VoidClosure?)
    
    ///
    func pushToNavigationController(viewController: UIViewController, animated: Bool)
    
    ///
    func restartPushedViewControllers()
}

/// Protocol describing an ability of coordinatpr to process finishing events from child coordinator. This may happen when subflow is completed
protocol ChildCoordinatorFinishing {
    /// Process a child coordinator finishing event right before child subflow will finish
    func willFinish(coordinator: any Coordinator)
    /// Process a child coordinator finishing event right after child subflow did finish
    func didFinish(coordinator: any Coordinator)
}

extension Coordinator {
    
    var pushedViewControllers: [Weak<UIViewController>] { _pushedViewControllers }
    
    func addChildCoordinator(_ coordinator: any Coordinator) {
        for element in childCoordinators {
            if element === coordinator {
                return
            }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: any Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func setToNavigationController(viewController: UIViewController?, animated: Bool, completion: VoidClosure?) {
        var viewControllers = navigationController.viewControllers
        let _pushedViewControllers = pushedViewControllers.compactMap({ $0.value })
        viewControllers.removeAll(where: { _pushedViewControllers.contains($0) })
        if let viewController = viewController {
            viewControllers.append(viewController)
        }
        if viewControllers.isEmpty {
            if let _ = navigationController.presentingViewController {
                navigationController.dismiss(animated: true, completion: completion)
            } else {
                fatalError("Unable to finish coordinator: Tried to set empty 'viewControllers' to 'navigationController'")
            }
        } else {
            navigationController.setViewControllers(viewControllers, animated: animated)
            if let completion = completion {
                if animated {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        completion()
                    })
                } else {
                    completion()
                }
            }
        }
        
        set(pushedViewControllers: (viewController == nil) ? [] : [Weak(value: viewController!)])
    }
    
    func setToNavigationController(viewControllers controllers: [UIViewController], animated: Bool, completion: VoidClosure?) {
        var viewControllers = navigationController.viewControllers
        let _pushedViewControllers = pushedViewControllers.compactMap({ $0.value })
        viewControllers.removeAll(where: { _pushedViewControllers.contains($0) })
        if !controllers.isEmpty {
            viewControllers.append(contentsOf: controllers)
        }
        if viewControllers.isEmpty {
            if let _ = navigationController.presentingViewController {
                navigationController.dismiss(animated: true, completion: completion)
            } else {
                fatalError("Unable to finish coordinator: Tried to set empty 'viewControllers' to 'navigationController'")
            }
        } else {
            navigationController.setViewControllers(viewControllers, animated: animated)
            if let completion = completion {
                if animated {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                        completion()
                    })
                } else {
                    completion()
                }
            }
        }
        
        set(pushedViewControllers: controllers.map({ Weak(value: $0) }))
    }
    
    func pushToNavigationController(viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: true)
        var newPushedViewControllers = pushedViewControllers.filter({ $0.value != nil })
        newPushedViewControllers.append(Weak(value: viewController))
        set(pushedViewControllers: newPushedViewControllers)
    }
    
    func restartPushedViewControllers() {
        set(pushedViewControllers: [], isRestart: true)
    }
    
    private func set(pushedViewControllers: [Weak<UIViewController>]) {
        set(pushedViewControllers: pushedViewControllers, isRestart: false)
    }
    
    private func set(pushedViewControllers: [Weak<UIViewController>], isRestart: Bool) {
        
        if pushedViewControllers.isEmpty, !isRestart {
            (output as? ChildCoordinatorFinishing)?.willFinish(coordinator: self)
        }
        _pushedViewControllers = pushedViewControllers
        if pushedViewControllers.isEmpty, !isRestart {
            (output as? ChildCoordinatorFinishing)?.didFinish(coordinator: self)
        }
    }
}

extension ChildCoordinatorFinishing where Self: Coordinator {
    func willFinish(coordinator: any Coordinator) {
        
    }
    
    func didFinish(coordinator: any Coordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}
