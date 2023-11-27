//
//  LocationRealmObject.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 23.11.2023.
//

import RealmSwift
import CoreLocation

final public class LocationRealmObject: Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var created = NSDate()

    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init()

        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
}
