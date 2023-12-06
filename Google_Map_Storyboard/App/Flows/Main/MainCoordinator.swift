//
//  MainCoordinator.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 04.12.2023.
//

import UIKit

final class MainCoordinator: BaseCoordinator {

    var onLogout: (() -> Void)?

    private var navigationController: UINavigationController?

    private let loginName: String?

    init(loginName: String?) {
        self.loginName = loginName
    }

    override func start() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MainViewController.self)

        viewController.onLogout = { [weak self] in
            self?.onLogout?()
        }

        viewController.onShowMap = { [weak self] in
            self?.showMap()
        }

        if let loginName = loginName {
            viewController.loginName = "Hello, \(loginName)"
        } else {
            viewController.loginName = nil
        }

        let navController = UINavigationController(rootViewController: viewController)
        setAsRoot(navController)
        self.navigationController = navController
    }

    func showMap() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

