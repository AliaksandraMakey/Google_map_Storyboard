//
//  ExtensionUIImageView.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 14.12.2023.
//

import UIKit

extension UIImageView {
    func rounded() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
