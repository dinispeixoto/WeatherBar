//
//  WeatherView.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 24/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Cocoa

class WeatherView: NSView {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var cityTextField: NSTextField!
    @IBOutlet weak var currentConditionsTextField: NSTextField!
    
    func update(_ weather: Weather) {
        DispatchQueue.main.async {
            self.cityTextField.stringValue = weather.city
            self.currentConditionsTextField.stringValue = "\(Int(weather.currentTemp)) °C and \(weather.conditions)"
        }
    }
    
}
