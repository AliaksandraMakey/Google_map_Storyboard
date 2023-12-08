//
//  LoginViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 20.11.2023.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    //MARK: - Properties
    var onAuthSucces: ((String) -> Void)?
    var onRecoveryAction: (() -> Void)?
    var onRegistationAction: ((String?) -> Void)?
    let disposeBag = DisposeBag()
    //MARK: - UI components
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLoginBindings()
  
    }
    //MARK: - Action
    @IBAction func loginTap(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return }
        onAuthSucces?(login)
        if UserManager.instance.authorize(login: login, password: password) {
                  onAuthSucces?(login)
              }
    }
    @IBAction func showForgotPasswordViewTap(_ sender: Any) {
        onRecoveryAction?()
    }
    @IBAction func showRegistrationViewTap(_ sender: Any) {
        guard let username = loginTextField.text,
              !username.replacingOccurrences(of: " ", with: "").isEmpty
        else {
            onRegistationAction?(nil)
            return
        }
        onRegistationAction?(username)
    }
    func configureLoginBindings() {
        Observable.combineLatest(loginTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
            .map { (userName, password) in
                !userName.isEmpty && password.count >= 6
            }
            .bind(to: loginButton.rx.isEnabled)
//            .subscribe{[weak self] isEnabled in
//                self?.loginButton.isEnabled = isEnabled
//            }
            .disposed(by: disposeBag)
    }
//    func configureLoginBindings(){
//        Observable.combineLatest(loginTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty)
//              .map { (login, password) in
//                  !login.isEmpty && !password.isEmpty
//              }
//              .subscribe{[weak self] isEnabled in
//                  self?.loginButton.isEnabled = isEnabled
//              }
//              .disposed(by: disposeBag)
//    }
}
