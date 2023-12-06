//
//  UserRealmObject.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 06.12.2023.
//

import RealmSwift

class UserRealmObject: Object {
    //MARK: - Properties
    @objc dynamic var login = ""
    @objc dynamic var password = ""
    @objc dynamic var created = NSDate()

    override class func primaryKey() -> String? {
        return "login"
    }
    //MARK: - Life cicle
    convenience init(login: String, password: String) {
        self.init()

        self.login = login
        self.password = password
    }
    //MARK: - Metods
    func toUser() -> User {
        return User(login: self.login, password: self.password, created: self.created)
    }
}
