//
//  LocationManager.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 24/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Foundation


class LocationManager: CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}
