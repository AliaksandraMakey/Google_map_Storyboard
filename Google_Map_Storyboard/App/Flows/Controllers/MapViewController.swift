//
//  ViewController.swift
//  Google_Map_Storyboard
//
//  Created by Александра Макей on 06.11.2023.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    //MARK: - Properties
    var userCoordinates = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    //    let coordinates = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    lazy var route = GMSPolyline()
    lazy var routePath = GMSMutablePath()
    lazy var locationManager = CLLocationManager()
    lazy var dataBase: DataBaseLocationProtocol = RealmDataBase()
    
    @IBOutlet weak var trackButton: UIButton!
    private var trackLocation = false
    //MARK: - UI components
    @IBOutlet weak var mapView: GMSMapView!
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    //MARK: - Setup UI
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: userCoordinates, zoom: 15)
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        //передвижение камеры с изменением локации пользователя
        mapView.isMyLocationEnabled = true
        configureMapStyle()
        mapView.delegate = self
    }
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        // разрешение юзера на отслеживание локации
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        //получение координат юзера в BackgroundMode
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
    //MARK: - Action
    @IBAction func addMarkerDidTap(_ sender: Any) {
        if marker == nil {
            mapView.animate(toLocation: userCoordinates)
            addMarker(at: userCoordinates)
        } else {
            removeMarker()
        }
    }
    
    @IBAction func trackUserLocationTap(_ sender: UIButton) {
        if trackLocation {
            stopLocation()
            finishTrack()
            sender.setTitle("Start tracking", for: .normal)
        } else {
            startLocation()
            startNewTrack()
            sender.setTitle("Stop tracking", for: .normal)
        }
    }
    @IBAction func actionShowPrevTrack(_ sender: UIButton) {
        if !trackLocation {
            showCurrentPath()
        } else {
            showStopTrackingAlert()
        }
    }
    @IBAction func showCurrentLocation(_ sender: Any) {
        guard let currentLocation = locationManager.location?.coordinate else { return }
                let camera = GMSCameraPosition.camera(withTarget: currentLocation, zoom: 17)
                mapView.animate(to: camera)
    }
    
    private func clearRoute() {
        route.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route.map = mapView
    }
    private func addMarker(at coordinate: CLLocationCoordinate2D,
                           title: String = "", snippet: String = "") {
        let marker = GMSMarker.init(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.title = title
        marker.snippet = snippet
        marker.map = mapView
    }
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    func configureMapStyle() {
        let style = MapStyle.getStyleJSON()
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: style)
        } catch {
            print(error)
        }
    }
    private func startNewTrack() {
        mapView.clear()
        clearRoute()
        
        route.strokeColor = .white
        route.strokeWidth = 5
        
        routePath = GMSMutablePath()
        route.map = mapView
    }
    private func finishTrack() {
        do {
            try dataBase.deletePath(name: dataBase.defaultPathName)
            
            guard let routePath = route.path else { return }
            for i in 0..<routePath.count() {
                let coordinate = routePath.coordinate(at: i)
                try dataBase.addPoint(path: dataBase.defaultPathName, coordinate: coordinate)
            }
            print("Save path to DataBase completed")
        } catch {
            print("Error occurred: \(error)")
        }
    }
    private func stopLocation() {
        locationManager.stopUpdatingLocation()
        trackLocation = false
    }
    private func startLocation() {
        locationManager.startUpdatingLocation()
        trackLocation = true
    }
    private func showCurrentPath() {
        do {
            let currentPath = try dataBase.loadPath(name: dataBase.defaultPathName)
            startNewTrack()
            for coord in currentPath {
                addPointToTrack(at: coord)
            }
            let bounds = GMSCoordinateBounds(path: routePath)
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
        } catch {
            print("Error occurred in showPreviuosPath: \(error)")
        }
    }
    private func addPointToTrack(at coordinate: CLLocationCoordinate2D)  {
        routePath.add(coordinate)
        route.path = routePath
    }
}
//MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let coordinate = locationManager.location?.coordinate
        else { return false }
        
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 14)
        mapView.animate(to: camera)
        return true
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let manulMarker = GMSMarker(position: coordinate)
        manulMarker.map = mapView
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        geoCoder?.reverseGeocodeLocation(location, completionHandler: { places, error in
            //получаем координаты марки по нажатию
            print(places?.last)
        })
    }
}

//MARK: - GMSMapViewDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if trackLocation {
            addPointToTrack(at: location.coordinate)
            let position = GMSCameraPosition(target: location.coordinate, zoom: 15)
            mapView.animate(to: position)
        }
        userCoordinates = location.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension MapViewController {
    
    func showStopTrackingAlert() {
        let stopTrackingAlert = UIAlertController(title: "Alert", message: "Do you want stop tracking?", preferredStyle: UIAlertController.Style.alert)
        
        stopTrackingAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] (action: UIAlertAction!) in
            self?.stopLocation()
            self?.showCurrentPath()
        }))
        stopTrackingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.startNewTrack()
        }))
        present(stopTrackingAlert, animated: true, completion: nil)
    }
}





