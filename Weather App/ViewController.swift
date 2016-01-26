//
//  ViewController.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/8/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

//TODO: Change background color to black at night
class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeAndDayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    
    //API object
    var api: API = API()
    
    //Location service object
    var locationService: LocationService = LocationService()
    
    //The timer for updating time and place
    var timer: NSTimer?
    
    //Feels like and current temperature label
    //Declared inside view controller so we can color different parts of it
    var temperatureString: NSString = ""
    var conditionString: NSString = ""
    
    /**
        Colors the temperature string based on gathered weather data.
     
        - Parameter temperature: The current temperature.
        - Parameter feelsLike: The temperature it feels like outside.
    */
    func prettifyTempLabels(temperature: Int, feelsLike: Int) {
        temperatureString = "\(temperature)°, feels like \(feelsLike)°."

        //Colors: TODO: Get these depending on the current temperature
        let temperatureColor: UIColor = UIColor(red: 127/255, green: 209/255, blue: 160/255, alpha: 1)
        let feelsLikeColor: UIColor = UIColor(red: 123/255, green: 66/255, blue: 251/255, alpha: 1)
        
        //Temperature label
        let tempLength = String(temperature).characters.count + 1 //+1 for the ° symbol
        let feelsLikeLength = String(feelsLike).characters.count + 1 //"    "
        let mutableTemp = NSMutableAttributedString(string: String(temperatureString), attributes: [NSFontAttributeName: temperatureLabel.font!])
        
        mutableTemp.addAttribute(NSForegroundColorAttributeName, value: temperatureColor, range: NSRange(location: 0, length: tempLength))
        mutableTemp.addAttribute(NSForegroundColorAttributeName, value: feelsLikeColor, range: NSRange(location: tempLength +  13, length: feelsLikeLength))
        temperatureLabel.attributedText = mutableTemp
    }
    
    /**
        Colors the condition string based on gathered weather data.
     
     - Parameter condition: The current weather conditions.
     */
    func prettifyConditionLabel(condition: Condition) {
        conditionString = "It's \(condition.getStatus()) out."
        
        let mutableCond = NSMutableAttributedString(string: String(conditionString), attributes: [NSFontAttributeName: temperatureLabel.font!])
        mutableCond.addAttribute(NSForegroundColorAttributeName, value: condition.getColorRepresentation(), range: NSRange(location: 5, length: condition.getLength()))
        
        conditionLabel.attributedText = mutableCond
    }
    
    //Fades in all the UI components from an alpha of zero
    func fadeInUI() {
        UIView.animateWithDuration(1) { () -> Void in
            self.locationLabel.alpha = 1
            self.timeAndDayLabel.alpha = 1
            self.temperatureLabel.alpha = 1
            self.conditionLabel.alpha = 1
            self.forecastTable.alpha = 1
        }
    }
    
    /**
        Updates the time and place label to the current time and
        location of the user.
    */
    func updateTimeAndPlace() {
        timeAndDayLabel.text = locationService.getTimeAndDayAsString()
        locationService.getCityAndStateString({ (city, state) -> Void in
            self.locationLabel.text = "\(city), \(state)"
        })
    }
    

    /**
        Sets up the user interface after the async call to the
        API returns with the current weather.
    */
    func setupUI() {
        if let location = locationService.getLocation() {
            api.getCurrentWeather(location) { (weather) -> Void in
                print("Current weather:")
                print("-----------------")
                print("Feels like: \(weather.feelsLike)")
                print("Temperature: \(weather.temperature)")
                print("Condition: \(weather.icon)")
                print("Humidity: \(weather.humidity * 100)%")
                print("Wind speed: \(weather.windSpeed)mph")
            
                self.prettifyTempLabels(weather.temperature, feelsLike: weather.feelsLike)
                self.prettifyConditionLabel(Condition(icon: weather.icon))
                self.fadeInUI() //Fade in UI after async callback
            }
            
            api.getDailyForecast(location) { (forecast) -> Void in
                //TODO
            }
            
            updateTimeAndPlace()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = "Test"
        return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Appeared")
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if locationService.hasAccess() {
            locationService.register()
            setupUI()
        } else {
            //TODO: Bug - doesn't update after user clicks allow. Only on next reload.
            locationService.promptUserToEnable()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateTimeAndPlace", userInfo: nil, repeats: true)
        locationLabel.alpha = 0
        timeAndDayLabel.alpha = 0
        temperatureLabel.alpha = 0
        conditionLabel.alpha = 0
        forecastTable.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

