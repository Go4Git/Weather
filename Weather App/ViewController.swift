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
        conditionLabel.text = "It's \(condition.getStatus()) out."
        let coloration: PartialColoration = PartialColoration(start: 5, length: condition.getLength(), color: condition.getColorRepresentation())
        conditionLabel.addPartialColor(coloration)
        
//        let mutableCond = NSMutableAttributedString(string: String(conditionString), attributes: [NSFontAttributeName: temperatureLabel.font!])
//        mutableCond.addAttribute(NSForegroundColorAttributeName, value: condition.getColorRepresentation(), range: NSRange(location: 5, length: condition.getLength()))
//        
//        conditionLabel.attributedText = mutableCond
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
                        //self.fadeInUI() //Fade in UI after async callback

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
      
        timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "updateTimeAndPlace", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

