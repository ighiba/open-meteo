//
//  LocationManager.swift
//  OpenMeteo
//
//  Created by Ivan Ghiba on 06.07.2023.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    var locationUpdateHandler: ((Float, Float) -> Void)?
    
    init(locationUpdateHandler: ((Float, Float) -> Void)? = nil) {
        self.locationUpdateHandler = locationUpdateHandler
        super.init()
        self.manager.delegate = self
    }
    
    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.first else { return }
        
        let latitude = Float(userLocation.coordinate.latitude)
        let longitude = Float(userLocation.coordinate.longitude)

        locationUpdateHandler?(latitude, longitude)

        manager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .restricted, .denied:
            print("Access to location denied")
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location update failed with error: \(error.localizedDescription)")
    }
}
