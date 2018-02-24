//
//  StatusMenuController.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 24/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Cocoa

class StatusMenuController: NSObject {
    
    @IBOutlet weak var weatherView: WeatherView!
    @IBOutlet weak var statusMenu: NSMenu!
    var weatherMenuItem: NSMenuItem!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let weatherAPI = WeatherAPI()
    
    override func awakeFromNib() {
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.menu = statusMenu
        
        weatherMenuItem = statusMenu.item(withTitle: "Weather")
        weatherMenuItem.view = weatherView
        
        updateWeather()
    }
    
    func updateWeather() {
        weatherAPI.fetchWeather("Braga") { weather in
            self.weatherView.update(weather)
        }
    }
    
    @IBAction func updateClicked(_ sender: NSMenuItem) {
        updateWeather()
    }
    
    @IBAction func quitClicked(sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
}
