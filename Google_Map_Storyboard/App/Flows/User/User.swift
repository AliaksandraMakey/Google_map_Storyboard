//
//  UserDB.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 06.12.2023.
//

import Foundation

final public class User: NSObject {
    //MARK: - Properties
    public let login: String
    public let password: String
    public let created: NSDate
    //MARK: - Life cicle
    public init(login: String, password: String, created: NSDate) {
        self.login = login
        self.password = password
        self.created = created
    }
    //MARK: - Metods
    func toRealm() -> UserRealmObject {
        return UserRealmObject(login: self.login, password: self.password)
    }
}
