//
//  Forecast.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/19/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation

/**
    Represents a daily forecast for a location.
*/
final class Forecast: ResponseObjectSerializable {
  
    let summary: String
    let data: [Weather]
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let daily = representation.valueForKeyPath("daily")!
        self.summary = daily.valueForKeyPath("summary") as! String
        let forecastData = daily.valueForKeyPath("data") as! [AnyObject]
        self.data = []
        
        for(var i = 0; i < forecastData.count; i++) {
            //print(forecastData[i])
            let obj = forecastData[i]
            let time = obj["time"] as! Double
            let date = NSDate(timeIntervalSince1970: time)
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.dateFormat = "MMM/dd, h:mma"

            print("\(formatter.stringFromDate(date)) | \(obj["summary"] as! String)")
        }
    }
    
}
