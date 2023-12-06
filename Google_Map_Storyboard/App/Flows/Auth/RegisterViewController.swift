//
//  RegisterViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 04.12.2023.
//

import UIKit

class RegisterViewController: UIViewController {
    //MARK: - Properties
    var loginName: String? {
        didSet {
            updateView()
        }
    }
    //MARK: - UI components
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    //MARK: - Action
    @IBAction func registerAction(_ sender: Any) {
        guard let loginName = loginTextField?.text,
              let password = passwordTextField?.text
        else { return }
        
        UserManager.instance.saveUser(login: loginName, password: password)
        
        let alertViewController = UIAlertController(
            title: "Successful registration",
            message: "User \(loginName) registered successful",
            preferredStyle: .alert
        )
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true){
                self?.loginTextField.text = nil
                self?.passwordTextField.text = nil
            }
        }))
        present(alertViewController, animated: true)
        
    }
    private func updateView() {
        loginTextField?.text = loginName
    }
}
