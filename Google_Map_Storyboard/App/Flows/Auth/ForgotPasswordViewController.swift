//
//  ForgotPasswordViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    //MARK: - Properties
    var loginText: String? {
        didSet {
            loginTextField?.text = loginText
        }
    }
    //MARK: - UI components
    @IBOutlet weak var loginTextField: UITextField!
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loginTextField.text = loginText
    }
    //MARK: - Action
    @IBAction func showPasswordTap(_ sender: Any) {
        
        guard let login = loginTextField.text,
              let user = UserManager.instance.loadUser(login: login)
        else { return }
        
        let alertViewController = UIAlertController(
            title: "Password",
            message: user.password,
            preferredStyle: .alert
        )
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        present(alertViewController, animated: true, completion: nil)
    }
}
