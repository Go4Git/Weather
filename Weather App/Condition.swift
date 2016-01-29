//
//  Condition.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/11/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import Foundation
import UIKit


/**
    Represents the different types of weather conditions.
*/
enum ConditionType: String {
    case Sunny, Clear, Raining, Snowing, Cloudy, Foggy, Stormy, Icy, Windy
}

var conditionDictionary: [String: ConditionType] = ["clear-day": .Clear, "clear-night": .Clear,
                                                    "rain": .Raining, "snow": .Snowing,
                                                    "sleet": .Icy, "wind": .Windy, "fog": .Foggy,
                                                    "partly-cloudy-day": .Cloudy, "partly-cloudy-night": .Cloudy]

/**
 Uses the API icon value as a more customizable way of displaying the
 weather conditions to the user.
 */
class Condition {
    
    let foggyColor = UIColor(red: 149/255, green: 172/255, blue: 220/255, alpha: 1)
    let rainingColor = UIColor(red: 128/255, green: 150/255, blue: 253/255, alpha: 1)
    let clearColor = UIColor(red: 162/255, green: 218/255, blue: 223/255, alpha: 1)
    
    //Using the icon value rather than summary from forecast.io as it's more descriptive
    //and allows for a better user experience
    var icon: String
    init(icon: String) {
        self.icon = icon
    }
    
    /**
        Gets the current weather condition as a user friendly string to be
        displayed to the user.

        - Returns: A user friendly string of the current weather conditions.
    */
    func getStatus() -> String {
        if let type = conditionDictionary[icon] {
            return type.rawValue.lowercaseString
        }
        
        return "unknown"
    }
    
    /**
        Gets the length of the current weather condition displayed. This
        value is used when calculating from and to what index the display
        strings should be colored.

        - Returns: The character length of the current weather condition.
    */
    func getLength() -> Int {
        return getStatus().characters.count
    }
    
    /**
        Gets the appropriate color for the current weather conditions.

        - Returns: A `UIColor` to match the current weather conditions.
     */
    func getColorRepresentation() -> UIColor {
        if let type = conditionDictionary[icon] {
            switch type {
            case .Foggy:
                return foggyColor
            case .Raining:
                return rainingColor
            case .Clear:
                return clearColor
            default:
                return foggyColor
            }
        }
        
        return foggyColor
    }
}