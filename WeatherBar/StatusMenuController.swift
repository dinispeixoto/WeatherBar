//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 24/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Cocoa
import CoreLocation

class StatusMenuController: NSObject, CLLocationManagerDelegate{
    
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var preferencesView: PreferencesView!
    @IBOutlet weak var statusMenu: NSMenu!
    var weatherMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // WeatherAPI
    let weatherAPI = WeatherAPI()
    
    // Location
    var locationManager = CLLocationManager()
    
    // Preferences
    let userPreferences = Preferences.init(temperatureInfo: true, unit: "ºC", unitInfo: "metric")
    struct Preferences {
        var temperatureInfo: Bool
        var unit: String
        var unitInfo: String
    }
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        // Making "Weather" menu item as weatherView
        weatherMenuItem = statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        
        // Starting locationManager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func preferencesClicked(_ sender: NSMenuItem) {
        
    }
    
    
    // Getting current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        updateWeather(userLocation)
        manager.stopUpdatingLocation()
    }
    
    // Update info based on the current location
    func updateWeather(_ userLocation: CLLocation) {
        fetchCountryAndCity(location: userLocation) { country, city in
            self.weatherAPI.fetchWeather("\(city)", preferences: self.userPreferences) { weather in
                self.weatherView.update(weather)
                // if()
                DispatchQueue.main.async { // Main Thread
                    self.statusItem.title = "\(weather.currentTemp) ºC"
                }
            }
        }
    }
    
    // Reverse geolocation, getting city based on current location
    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                NSLog("\(error)")
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality {
                completion(country, city)
            }
        }
    }
}
