//
//  PathRealmObject.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 23.11.2023.
//

import RealmSwift
import CoreLocation

final public class PathRealmObject: Object {
    @objc dynamic var name = ""
    @objc dynamic var created = NSDate()
    let path = List<LocationRealmObject>()
}
