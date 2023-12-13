//
//  UserManager.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 01.12.2023.
//

import Foundation

final class UserManager {
    
    static let instance = UserManager()
    //MARK: - Properties
    private(set) var currentUser: User?
    private var dataBase: DataBaseAuthProtocol = RealmService()
    
    var isAuthorized: Bool {
        return currentUser != nil
    }
    //MARK: - Metods
    func authorize(login: String, password: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            guard let user = self.dataBase.loadUser(login: login) else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            guard login == user.login, password == user.password else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.currentUser = user
                completion(true)
            }
        }
    }
    
    public func loadUser(login: String) -> User? {
          return dataBase.loadUser(login: login)
      }

      public func saveUser(login: String, password: String) {
          dataBase.saveUser(user: User(login: login, password: password, created: NSDate()))
      }
    
    func logout() {
        currentUser = nil
    }
    
    private init() {}
    
}
