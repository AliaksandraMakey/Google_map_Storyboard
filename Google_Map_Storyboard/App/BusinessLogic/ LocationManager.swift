//
//   LocationManager.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 07.12.2023.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()

    static let instance = LocationManager()

    let authorithationStatus: Observable<CLAuthorizationStatus>
     private let _authorithationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)

     let location: Observable<CLLocationCoordinate2D>
     private let _location = PublishRelay<CLLocationCoordinate2D>()

    private override init() {
        self.authorithationStatus = _authorithationStatus.asObservable()
         self.location = _location.asObservable()
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true

        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func requestAuthorithation() {
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        _authorithationStatus.accept(manager.authorizationStatus)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach{
                  _location.accept($0.coordinate)
              }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
