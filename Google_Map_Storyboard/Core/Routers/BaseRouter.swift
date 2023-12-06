//
//  BaseRouter.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import UIKit

class BaseRouter: NSObject {

    @IBOutlet weak var controller: UIViewController!

    func show(_ controller: UIViewController, style: ShowStyle) {
        switch style {
        case let .push(animated):
            self.controller.navigationController?.pushViewController(controller, animated: animated)
        case let .modal(animated):
            self.controller.present(controller, animated: animated, completion: nil)
        case .root:
            UIWindow.keyWindow?.rootViewController = controller
        }
    }

}
