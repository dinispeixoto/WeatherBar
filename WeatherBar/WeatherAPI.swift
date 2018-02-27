//
//  WeatherAPI.swift
//  WeatherBar
//
//  Created by Dinis Peixoto on 24/02/2018.
//  Copyright © 2018 Dinis Peixoto. All rights reserved.
//

import Foundation

class WeatherAPI {
    
    let API_KEY = "6979706d12688265a5ba7d3b5590625f"
    let BASE_URL = "https://api.openweathermap.org/data/2.5/weather"
    
    struct Weather: CustomStringConvertible {
        var city: String                        // City name
        var icon: String                        // Icon
        var currentTemp: Float                  // Current temperature
        var conditions: String                  // Weather conditions
        var unit: String                        // Temperature Unit
        
        var description: String {
            return "\(city): \(currentTemp) \(unit) and \(conditions)"
        }
    }
    
    // Request weather on current location
    func fetchWeather(_ query: String, preferences: StatusMenuController.Preferences, success: @escaping (Weather) -> Void) {
        let session = URLSession.shared
        // url-escape the query string we're passing
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: "\(BASE_URL)?APPID=\(API_KEY)&units=\(preferences.unitInfo)&q=\(escapedQuery!)")
        // NSLog("url: \(url!)") - used it for debugging
        
        let task = session.dataTask(with: url!) { data, response, err in
            // first check for a hard error
            if let error = err {
                NSLog("weather api error: \(error)")
            }
            
            // then check the response code
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // all good!
                    if let weather = self.weatherFromJSONData(data!, unit: preferences.unit) {
                        success(weather)
                    }
                case 401: // unauthorized
                    NSLog("weather api returned an 'unauthorized' response. Did you set your API key?")
                default:
                    NSLog("weather api returned response: %d %@", httpResponse.statusCode, HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
    
    // Parsing received JSON
    func weatherFromJSONData(_ data: Data, unit: String) -> Weather? {
        typealias JSONDict = [String:AnyObject]
        let json : JSONDict
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: []) as! JSONDict
        } catch {
            NSLog("JSON parsing failed: \(error)")
            return nil
        }
        
        var mainDict = json["main"] as! JSONDict
        var weatherList = json["weather"] as! [JSONDict]
        var weatherDict = weatherList[0]
        
        
        
        let weather = Weather(
            city: json["name"] as! String,
            icon: weatherDict["icon"] as! String,
            currentTemp: mainDict["temp"] as! Float,
            conditions: weatherDict["main"] as! String,
            unit: unit
        )
        
        return weather
    }
}
