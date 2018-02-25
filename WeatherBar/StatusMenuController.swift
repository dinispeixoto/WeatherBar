//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 24/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Cocoa
import Foundation
import MapKit
import CoreLocation

class StatusMenuController: NSObject, CLLocationManagerDelegate{
    
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var statusMenu: NSMenu!
    var weatherMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // WeatherAPI
    let weatherAPI = WeatherAPI()
    
    // Location
    var locationManager = CLLocationManager()
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        weatherMenuItem = statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        updateWeather(userLocation)
        
        manager.stopUpdatingLocation()
    }
    
    func updateWeather(_ userLocation: CLLocation) {
        NSLog("user latitude = \(userLocation.coordinate.latitude)")
        NSLog("user longitude = \(userLocation.coordinate.longitude)")
        
        fetchCountryAndCity(location: userLocation) { country, city in
            NSLog("country:", country)
            NSLog("city:", city)
        }
        
        //weatherAPI.fetchWeather(city) { weather in
        //    self.weatherView.update(weather)
        //}
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
