//
//  LocationManager.swift
//  OhMyPlant
//
//  Created by Alex Yang on 2021-12-18.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    var location: CLLocationCoordinate2D?
    
    var city: String?
    
    var locationUpdatedHandler: ((String, CLLocationCoordinate2D)->Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        let geoCoder = CLGeocoder()
        if let clLocation = locations.first {
            geoCoder.reverseGeocodeLocation(clLocation) { placemarks, error in
                self.city = placemarks?.first?.locality
                if let location = self.location , let city = self.city{
                    self.locationUpdatedHandler?(city,location)
                }
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
