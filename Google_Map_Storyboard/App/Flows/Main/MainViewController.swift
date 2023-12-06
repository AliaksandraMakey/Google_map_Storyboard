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
    private func updateView() {
       loginNameLabel?.text = "Hello \(loginName)"
    }
    
}
