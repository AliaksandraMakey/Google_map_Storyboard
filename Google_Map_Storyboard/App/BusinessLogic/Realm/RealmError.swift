//
//  RealmError.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 23.11.2023.
//

import Foundation

enum RealmError: Error {
    case databaseAccessError(error: Error)
    case writeError(error: NSError)
    case readError(description: String)
    case deleteError(description: String)
    case pathNotFound

    var description: String {
        switch self {
        case .databaseAccessError(let error):
            return "Could not access Realm database: \(error.localizedDescription)"
        case .writeError(let error):
            return "Could not write to Realm database: \(error.localizedDescription)"
        case .readError(let description):
            return "Could not read from Realm database: \(description)"
        case .deleteError(let description):
            return "Could not delete from Realm database: \(description)"
        case .pathNotFound:
            return "Path not found in Realm database"
        }
    }
}
