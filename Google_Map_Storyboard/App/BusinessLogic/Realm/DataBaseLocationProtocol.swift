//
//   DataBaseLocationProtocol.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 23.11.2023.
//

import Foundation
import CoreLocation

protocol DataBaseLocationProtocol {

    var defaultPathName: String { get }

    func loadPath(name: String) throws -> [CLLocationCoordinate2D]
    func savePath(name: String, path: [CLLocationCoordinate2D]) throws
    func deletePath(name: String) throws

    func addPoint(path name: String, coordinate: CLLocationCoordinate2D) throws
}
