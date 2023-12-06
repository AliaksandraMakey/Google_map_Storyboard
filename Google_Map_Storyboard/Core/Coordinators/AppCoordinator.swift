//
//  AppCoordinator.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 04.12.2023.
//

import Foundation

final class AppCoordinator: BaseCoordinator {

    private var loginName: String?

    override func start() {
        if UserManager.instance.isAuthorized {
            showMainFlow()
        } else {
            showAuthFlow()
        }
    }

    func showMainFlow() {
        let coordinator = MainCoordinator(loginName: loginName)
        coordinator.onLogout = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func showAuthFlow() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] username in
            self?.loginName = username
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
