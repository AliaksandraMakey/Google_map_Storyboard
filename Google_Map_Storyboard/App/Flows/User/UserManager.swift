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
    func authorize(login: String, password: String) -> Bool {
        guard let user = dataBase.loadUser(login: login) else {
            return false
        }
        guard login == user.login,
              password == user.password else {
            return false
        }
        self.currentUser = user
        return true
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
