//
//  LocationService.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/10/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//


//TODO: ?
/**
    It is safe to start location services before the authorization status of your app is determined. Although you can start location services, those services do not deliver any data until the authorization status changes to kCLAuthorizationStatusAuthorizedAlways or kCLAuthorizationStatusAuthorizedWhenInUse. To be notified when the authorization status changes, implement the locationManager:didChangeAuthorizationStatus: method in your location manager delegate.

    From: https://developer.apple.com/library/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/index.html#//apple_ref/occ/instm/CLLocationManager/requestWhenInUseAuthorization
*/
import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject, CLLocationManagerDelegate {
    
    //Location manager used to get the user's current location
    let locationManager = CLLocationManager()
    
    /**
        Handles the setup process for the `CLLocationManager`.
    */
    func register() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("Location services are enabled")
            let status = CLLocationManager.authorizationStatus()
            
            if status != CLAuthorizationStatus.Denied {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        } else {
            //TODO: Inform user
            print("Location services are disabled")
        }
    }
    
    /**
        Determines whether or not the app has access to location services.

        - Returns: A boolean flag of true or false.
    */
    func hasAccess() -> Bool {
        return CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Denied
    }
    
    func promptUserToEnable() {
        print("Prompt user to enable location services")
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("CLAuthorizationStatus updated to: \(status)")
        //TODO: Re-register
    }

    
    /**
        Gets the user's current location.

        - Returns: The user's current `Location`.
    */
    func getLocation() -> Location? {
        if let coordinate = locationManager.location?.coordinate {
            return Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
        } else {
            return nil
        }
    }
    
    func getCityAndStateString(completionHandler: (city: String, state: String) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(locationManager.location!) { (mark: [CLPlacemark]?, error: NSError?) -> Void in
            if let data = mark {
                let city = data[0].locality!
                let state = data[0].administrativeArea!
                completionHandler(city: city, state: state)
            } else {
                print(error)
            }
        }
    }
    
    /**
     Used to get the user's current time and day for their time zone.
     
     - Returns: The current time and day for the user's time zone.
     */
    func getTimeAndDayAsString() -> String {
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.dateFormat = "MMM, h:mma"
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        return formatter.stringFromDate(today)
    }
}
