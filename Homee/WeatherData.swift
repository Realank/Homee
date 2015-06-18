//
//  SwtichData.swift
//  Homee
//
//  Created by Realank-Mac on 15/4/5.
//  Copyright (c) 2015年 Realank-Mac. All rights reserved.
//

import UIKit

protocol WeatherDataHasUpdateDelegate{
    func weatherDataHasUpdate()
}

struct weatherInfoPerDay {
    var weekNum : String
    var weatherStat = "天气"
    var wind = "风向"
    var temprature = "N/A℃"
    init(week:String){
        weekNum = week

    }
}

class WeatherInfo {
    var weekNum = [weatherInfoPerDay]()
    var pm25 = "0"
    init(){
        weekNum.append(weatherInfoPerDay(week: "今日天气"))
        weekNum.append(weatherInfoPerDay(week: "明日天气"))
    }
}


class WeatherData : receiveSocketMsgDelegate {
    
    var weatherDataHasUpdateDelegate : WeatherDataHasUpdateDelegate?

    let sockcom = SocketComm()
    let weatherInfo = WeatherInfo()
    
    init(){
        sockcom.receiverDelegater = self
    }
    
    func reloadData(){
        sockcom.communicate(dataToSend: "WTHR:CHEK:WEEK:0000")
        sockcom.communicate(dataToSend: "WTHR:CHEK:WTHR:0000")
        sockcom.communicate(dataToSend: "WTHR:CHEK:WIND:0000")
        sockcom.communicate(dataToSend: "WTHR:CHEK:TEMP:0000")
        sockcom.communicate(dataToSend: "WTHR:CHEK:PM25:0000")
        
        sockcom.communicate(dataToSend: "WTHR:CHEK:WEEK:0001")
        sockcom.communicate(dataToSend: "WTHR:CHEK:WTHR:0001")
        sockcom.communicate(dataToSend: "WTHR:CHEK:WIND:0001")
        sockcom.communicate(dataToSend: "WTHR:CHEK:TEMP:0001")
    }
    
    
    func receivedBufferFromSocket(count: Int, data: String) {
        dispatch_async(dispatch_get_main_queue()){
            var strArray = data.split(":")
            println("WeatherData received Socket Answer is: \(strArray) bytes: \(count)")
            
            
            if strArray[0] == "WTHR" && strArray[1] == "BACK" {
                
                let day = strArray[3].toInt() ?? 0
                let info = strArray[4]
                
                if strArray[2] == "WEEK" {
                    self.weatherInfo.weekNum[day].weekNum = info
                } else if strArray[2] == "WTHR" {
                    self.weatherInfo.weekNum[day].weatherStat = info
                } else if strArray[2] == "WIND" {
                    self.weatherInfo.weekNum[day].wind = info
                } else if strArray[2] == "TEMP" {
                    self.weatherInfo.weekNum[day].temprature = info
                } else if strArray[2] == "PM25" {
                    self.weatherInfo.pm25 = info
                } else {
                    println("Error, can't recognise data in WeatherData")
                    return
                }
                
                
                self.weatherDataHasUpdateDelegate?.weatherDataHasUpdate()
            }


            
        }
    }
    
    
}
