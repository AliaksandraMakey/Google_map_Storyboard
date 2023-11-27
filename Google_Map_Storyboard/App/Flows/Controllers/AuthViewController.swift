//
//  AuthViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 20.11.2023.
//

import UIKit

class AuthViewController: UIViewController {
    //MARK: - Properties
    var timer: Timer?
    var beginBackgroundTask: UIBackgroundTaskIdentifier?
    //MARK: - UI components
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTimer()
    }
    //MARK: - Action
    func configureTimer() {

        beginBackgroundTask = UIApplication.shared
            .beginBackgroundTask { [weak self]
            in
            guard let strongSelf = self else { return }
                UIApplication.shared.endBackgroundTask(strongSelf.beginBackgroundTask!)
                strongSelf.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
            
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            print(Date())
        }
    }
}
