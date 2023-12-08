//
//  AuthCoordinator.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 04.12.2023.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {

    var onFinishFlow: ((String) -> Void)?

    private var navigationController: UINavigationController?

    override func start() {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)

        viewController.onAuthSucces = { [weak self] login in
            self?.onFinishFlow?(login)
        }

        viewController.onRecoveryAction = { [weak self] in
            self?.showRecovery()
        }

        viewController.onRegistationAction = {[weak self] login in
            self?.showRegistration(loginName: login)
        }

        let navigationController = UINavigationController(rootViewController: viewController)
        setAsRoot(navigationController)
        self.navigationController = navigationController
    }

    func showRecovery() {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(ForgotPasswordViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }

    func showRegistration(loginName: String?) {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RegisterViewController.self)
        viewController.loginName = loginName
        navigationController?.pushViewController(viewController, animated: true)
    }

}
