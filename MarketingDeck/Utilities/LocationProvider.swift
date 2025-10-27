//
//  LocationProvider.swift
//  PropertyInspector
//
//  Created by Michael Crawford on 9/16/25.
//

import CoreLocation

class LocationProvider: NSObject {
    fileprivate let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func startUpdatingLocation() {
        requestPermissionIfNeeded()
        locationManager.startUpdatingLocation()
    }

    private func requestPermissionIfNeeded() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Start updating location when authorized
            manager.startUpdatingLocation()
        case .denied, .restricted:
            // Stop updates if not authorized
            manager.stopUpdatingLocation()
        case .notDetermined:
            // Request authorization if not determined yet
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: Use new location ...
    }
}
