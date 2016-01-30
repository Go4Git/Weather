//
//  ViewController.swift
//  Weather App
//
//  Created by Stephen Andrews on 1/8/16.
//  Copyright © 2016 Stephen Andrews. All rights reserved.
//

import UIKit
import ForecastIO

//TODO: Change background color to black at night
class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeAndDayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var forecastTable: UITableView!
    
    //ForecastIO wrapper by Satyam Ghodasara
    let forecastIOClient: APIClient = APIClient(apiKey: "b58958b9ee32f22df382b6f0559361e8")
    
    //Location service object
    let locationService: LocationService = LocationService()
    
    //The timer for updating time and place
    var timer: NSTimer?
    
    /**
        Colors the temperature string based on gathered weather data.
     
        - Parameter temperature: The current temperature.
        - Parameter feelsLike: The temperature it feels like outside.
    */
    func prettifyTempLabels(temperature: Int, feelsLike: Int) {
        //Colors: TODO: Get these depending on the current temperature
        let temperatureColor: UIColor = UIColor(red: 127/255, green: 209/255, blue: 160/255, alpha: 1)
        let feelsLikeColor: UIColor = UIColor(red: 123/255, green: 66/255, blue: 251/255, alpha: 1)
        
        dispatch_async(dispatch_get_main_queue(), {
            self.temperatureLabel.text = "\(temperature)°, feels like \(feelsLike)°."
            
            let tempLength = String(temperature).characters.count + 1 //+1 for the ° symbol
            let tempColoration = PartialColoration(start: 0, length: tempLength, color: temperatureColor);

            let feelsLikeLength = String(feelsLike).characters.count + 1 //+1 for the ° symbol
            let feelsLikeColoration = PartialColoration(start:  tempLength + 13, length: feelsLikeLength, color: feelsLikeColor)
            
            self.temperatureLabel.addPartialColor(tempColoration, feelsLikeColoration)
        })
    }
    
    /**
        Colors the condition string based on gathered weather data.
     
     - Parameter condition: The current weather conditions.
     */
    func prettifyConditionLabel(condition: Condition) {
        dispatch_async(dispatch_get_main_queue(), {
          self.conditionLabel.text = "It's \(condition.getStatus()) out."
          let coloration: PartialColoration = PartialColoration(start: 5, length: condition.getLength(), color: condition.getColorRepresentation())
          self.conditionLabel.addPartialColor(coloration)
        })
    }
    
    //Fades in all the UI components from an alpha of zero
    func fadeInUI() {
        dispatch_async(dispatch_get_main_queue(), {
            UIView.animateWithDuration(1) { () -> Void in
                self.locationLabel.alpha = 1
                self.timeAndDayLabel.alpha = 1
                self.temperatureLabel.alpha = 1
                self.conditionLabel.alpha = 1
                self.forecastTable.alpha = 1
            }
        })
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
          print("Location determined... Attempting to grab weather.");
            forecastIOClient.getForecast(latitude: location.latitude,
                longitude: location.longitude, completion: { (forecast, error) -> Void in
                    print("Current weather:")
                    print("-----------------")
                    if let currently = forecast?.currently {
                        print("Feels like: \(currently.apparentTemperature!)")
                        print("Temperature: \(currently.temperature!)")
                        print("Condition: \(currently.icon!)")
                        print("Humidity: \(currently.humidity! * 100)%")
                        print("Wind speed: \(currently.windSpeed!)mph")
                        
                        self.prettifyTempLabels(Int(currently.temperature!), feelsLike: Int(currently.apparentTemperature!))
                        self.prettifyConditionLabel(Condition(icon: currently.icon!.rawValue))
                        self.fadeInUI() //Fade in UI after async callback
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateTimeAndPlace", userInfo: nil, repeats: true)
                    }
            })
          
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
        //setupUI() //Causes it to call twice on startup
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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

