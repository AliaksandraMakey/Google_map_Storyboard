//
//  MainViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import UIKit

final class MainViewController: UIViewController {
    //MARK: - Properties
    var onShowMap: (() -> Void)?
    var onLogout: (() -> Void)?
    var onTakePictures: (() -> Void)?
    var loginName: String? {
        didSet {
            updateView()
        }
    }
    //MARK: - UI components
    @IBOutlet weak var loginNameLabel: UILabel!
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    //MARK: - Action
    @IBAction func showMap(_ sender: Any) {
        onShowMap?()
    }
    @IBAction func logout(_ sender: Any) {
        UserManager.instance.logout()
        onLogout?()
    }
    @IBAction func takePicturesAction(_ sender: Any) {
        onTakePictures?()
    }
    private func updateView() {
        loginNameLabel?.text = "Hello \(loginName)"
    }
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, 
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = extractImage(from: info) {
            print(image)
        }
        picker.dismiss(animated: true)
    }

    private func extractImage(from info: [UIImagePickerController.InfoKey: Any]) -> UIImage? {
        if let editedImage = info[.editedImage] as? UIImage {
            return editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            return originalImage
        } else {
            return nil
        }
    }
}
