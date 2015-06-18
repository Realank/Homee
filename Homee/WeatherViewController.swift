//
//  WeatherViewController.swift
//  Homee
//
//  Created by Realank-Mac on 15/6/18.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, WeatherDataHasUpdateDelegate {
    
    @IBOutlet weak var day1weekNum: UILabel!
    @IBOutlet weak var day1weather: UILabel!
    @IBOutlet weak var day1wind: UILabel!
    @IBOutlet weak var day1temperature: UILabel!
    @IBOutlet weak var day1pm25: UILabel!

    @IBOutlet weak var day2weekNum: UILabel!
    @IBOutlet weak var day2weather: UILabel!
    @IBOutlet weak var day2wind: UILabel!
    @IBOutlet weak var day2temperature: UILabel!
    
    
    
    let weatherData = WeatherData()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherData.weatherDataHasUpdateDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        weatherData.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func weatherDataHasUpdate(){
        day1weekNum.text = weatherData.weatherInfo.weekNum[0].weekNum
        day1weather.text = weatherData.weatherInfo.weekNum[0].weatherStat
        day1wind.text = weatherData.weatherInfo.weekNum[0].wind
        day1temperature.text = weatherData.weatherInfo.weekNum[0].temprature
        day1pm25.text = weatherData.weatherInfo.pm25
        
        day2weekNum.text = weatherData.weatherInfo.weekNum[1].weekNum
        day2weather.text = weatherData.weatherInfo.weekNum[1].weatherStat
        day2wind.text = weatherData.weatherInfo.weekNum[1].wind
        day2temperature.text = weatherData.weatherInfo.weekNum[1].temprature
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
