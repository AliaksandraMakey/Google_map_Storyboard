//
//  BaseCoordinator.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import UIKit

class BaseCoordinator {

    var childCoordinators: [BaseCoordinator] = []

    func start() {
        assertionFailure("You must implement this method")
    }

    func addDependency(_ coordinator: BaseCoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard
            !childCoordinators.isEmpty,
            let coordinator = coordinator
        else { return }

        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    func setAsRoot(_ controller: UIViewController) {
        UIWindow.keyWindow?.rootViewController = controller
    }

}
