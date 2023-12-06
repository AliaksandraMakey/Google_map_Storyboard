//
//  AuthRouter.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import UIKit

final class AuthRouter: BaseRouter {
    
    func toMainView() {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MainViewController.self)
        let navController = UINavigationController(rootViewController: viewController)
        show(navController, style: .root)
    }
    
    func toForgotPasswordView(userName: String?) {
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(ForgotPasswordViewController.self)
        show(viewController, style: .push(animated: true))
    }
    func toRegistrationView(userName: String?){
        let viewController = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RegisterViewController.self)
        show(viewController, style: .push(animated: true))
    }
}
