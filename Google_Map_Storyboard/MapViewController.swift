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
    let coordinates = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    var marker: GMSMarker?
    var geoCoder: CLGeocoder?
    //линия, которая начинает рисоваться от точки а к б
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager: CLLocationManager?
    //    lazy var route = GMSPolyline()
    //    lazy var routePath = GMSMutablePath()
    //    lazy var locationManager = CLLocationManager()
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
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 15)
        mapView.camera = camera
        mapView.translatesAutoresizingMaskIntoConstraints = false
        //передвижение камеры с изменением локации пользователя
        mapView.isMyLocationEnabled = true
        configureMapStyle()
        mapView.delegate = self
    }
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // разрешение юзера на отслеживание локации
        if locationManager?.authorizationStatus == .notDetermined {
            locationManager?.requestWhenInUseAuthorization()
        }
        //получение координат юзера в BackgroundMode
        locationManager?.allowsBackgroundLocationUpdates = true
        
    }
    //MARK: - Action
    @IBAction func addMarkerDidTap(_ sender: Any) {
        if marker == nil {
            mapView.animate(toLocation: coordinates)
            addMarker()
        } else {
            removeMarker()
        }
    }
    
    @IBAction func updateLocationTap(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }
    
    private func addMarker() {
        let symbolName = "pin.fill"
        
        if let image = UIImage(systemName: symbolName) {
            marker = GMSMarker(position: coordinates)
            marker?.icon = image
            marker?.title = "Marker"
            marker?.snippet = "My new marker"
            marker?.map = mapView
        } else {
            marker = GMSMarker(position: coordinates)
            marker?.icon = GMSMarker.markerImage(with: .blue)
            marker?.map = mapView
        }
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
}
//MARK: - GMSMapViewDelegate
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let manulMarker = GMSMarker(position: coordinate)
        manulMarker.map = mapView
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        geoCoder?.reverseGeocodeLocation(location, completionHandler: { places, error in
            print(places?.last)
        })
    }
}

//MARK: - GMSMapViewDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Добавляем координату в маршрут
        routePath?.add(location.coordinate)
        
        let locationsCount = routePath?.count() ?? 0
        
        if locationsCount % 5 == 0 {
            // Добавляем маркер каждые 5 шагов
            let blueMarker = GMSMarker(position: location.coordinate)
            blueMarker.icon = GMSMarker.markerImage(with: .blue)
            blueMarker.map = mapView
        }
        
        // Отрисовываем путь
            route = GMSPolyline(path: routePath)
            route?.strokeColor = .red
            route?.strokeWidth = 2.5
            route?.map = mapView

        let position = GMSCameraPosition(target: location.coordinate, zoom: 15)
        mapView.animate(to: position)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}







