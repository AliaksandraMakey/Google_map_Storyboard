//
//  EditPhotoViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 14.12.2023.
//

import UIKit

class EditPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView? {
        didSet {
            imageView?.contentMode = .scaleAspectFill
        }
    }

    var image: UIImage? {
        didSet {
            imageView?.image = image
        }
    }

    var onSave: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView?.image = image
    }

    @IBAction func saveAction(_ sender: Any) {
        onSave?()
    }
}
