//
//  PreferencesViewController.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 27/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSWindowController {

    @IBOutlet weak var temperatureInfo: NSButton!
    @IBOutlet weak var unitInfo: NSPopUpButton!
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    @IBAction func cancelClicked(_ sender: Any) {
    }
    
    @IBAction func saveClicked(_ sender: Any) {
    }
}
