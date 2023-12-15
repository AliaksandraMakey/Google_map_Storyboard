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
        super.init()
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
        viewController.onTakePictures = { [weak self] in
            self?.showPhotoPicker()
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
    func showSelfi(image: UIImage) {
        let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(EditPhotoViewController.self)
        viewController.image = image
        
        viewController.onSave = { [weak viewController] in
            if let image = viewController?.image {
                let targetSize = CGSize(width: 50, height: 50)
                let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
                FilesManager.saveImage(imageName: FilesManager.userImageName, image: scaledImage)
            }
            viewController?.dismiss(animated: true, completion: nil)
        }
        navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func showPhotoPicker() {
        var sourceType: UIImagePickerController.SourceType
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sourceType = .camera
        }
        else {
            sourceType = .photoLibrary
        }
        let viewController = UIImagePickerController()
        viewController.sourceType = sourceType
        viewController.allowsEditing = true
        viewController.delegate = self
        navigationController?.present(viewController, animated: true, completion: nil)
    }
}

extension MainCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = getImageFrom(info: info) {
            picker.dismiss(animated: true) { [weak self] in
                self?.showSelfi(image: image)
            }
        }
    }
    
    func getImageFrom(info: [UIImagePickerController.InfoKey : Any]) -> UIImage? {
        if let image = info[.editedImage] as? UIImage { return image }
        if let image = info[.originalImage] as? UIImage { return image }
        return nil
    }
}
