//
//  Location.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/9/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation

/**
    Manages all location related tasks.
*/
class Location {
    
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /** 
        Gets the URL extension needed to make the API call to forecast.io.

        - Returns: String representation of latitude and longitude for API call.
    */
    func getURLExtension() -> String {
        return String(latitude) + "," + String(longitude)
    }
    
}

