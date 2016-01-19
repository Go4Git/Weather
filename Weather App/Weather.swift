//
//  Weather.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/9/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation
import UIKit

final class Weather: ResponseObjectSerializable {
    
    let feelsLike: Int
    let temperature: Int
    let icon: String
    let summary: String
    let humidity: Double
    let windSpeed: Int
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let currently = representation.valueForKeyPath("currently")!
        self.feelsLike = currently.valueForKeyPath("apparentTemperature") as! Int
        self.temperature = currently.valueForKeyPath("temperature") as! Int
        self.icon = currently.valueForKeyPath("icon") as! String
        self.summary = currently.valueForKeyPath("summary") as! String
        self.humidity = currently.valueForKeyPath("humidity") as! Double
        self.windSpeed = currently.valueForKeyPath("windSpeed") as! Int
    }
}
