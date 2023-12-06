//
//  UIStoryboard.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import UIKit

extension UIStoryboard {

    func instantiateViewController<T: UIViewController>(_: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
        else {
            fatalError("View controller с идентификатором \(T.storyboardIdentifier) не найден")
        }
        return viewController
    }

    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController =
                self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("View controller с идентификатором \(T.storyboardIdentifier) не найден")
        }
        return viewController
    }

}
