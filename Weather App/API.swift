//
//  API.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/8/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/**
    Responsible for interacting with the forecast.io API
*/
class API {
    
    //The API key for forecast.io
    let apiKey: String = "b58958b9ee32f22df382b6f0559361e8"
    
    //The base url to create api requests with
    let baseURL: String = "https://api.forecast.io/forecast/"
    
    //The full request URL without the location extension
    var requestURL: String {
        return baseURL + apiKey + "/"
    }
    
    /**
        Sends an API request to forcast.io with the specified location. The
        response is then used to serialize data into the `Weather` class for 
        later use.
     
        - Parameter loc: The location to get the weather for.
     
        - Returns: A completion handler containing the current weather.
    */
    func getCurrentWeather(loc: Location, completionHandler: (weather: Weather) -> Void) {
        if let url: String = requestURL + loc.getURLExtension() {
            Alamofire.request(.GET, url)
                .responseObject { (response: Response<Weather, NSError>) in
                    if let currently = response.result.value {
                        completionHandler(weather: currently)
                    } else {
                        print(response.result.error)
                    }
            }
        }
    }
}










