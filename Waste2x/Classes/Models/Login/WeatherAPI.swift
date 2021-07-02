//
//  WeatherAPI.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 11/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper

class WeatherAPI : Mappable {
    var cod = ""
    var message = Int()
    var cnt = Int()
    var list = [WeatherListResponce]()
    var city : WeatherCityResponce?

    required init?(map: Map) { }

    func mapping(map: Map) {

        cod   <- map["cod"]
        message <- map["message"]
        cnt    <- map["cnt"]
        list  <- map["list"]
        city   <- map["city"]
    }
    
    class func WeatherAPICall(_ completion: @escaping RawCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.weatherAPi{ result, error, status,message in
            
            Utility.hideLoading()
            if error == nil {
                if let data = Mapper<WeatherAPI>().map(JSON: result as! [String : Any]) {
                    let weather = data.toJSONString()
                    DataManager.shared.setWeather(weather: weather ?? "")
                    completion(data, nil, status,message)
                } else {
                    completion(nil, nil, status,message)
                }
                
            } else {
                 completion(nil, error, status,message)
            }
        }
    }

}

class WeatherListResponce : Mappable {
    
    var dt = Int()
    var main : WeatherListMainResponce?
    var weather : WeatherListWeatherResponce?
    var dtTxt = String()
    required init?(map: Map) { }

    func mapping(map: Map) {
        dt <- map["dt"]
        main <- map["main"]
        weather <- map["weather"]
        dtTxt <- map["dt_txt"]
    }
}
class WeatherCityResponce : Mappable {
    
    var country = "haid3r"

    required init?(map: Map) { }

    func mapping(map: Map) {
        country <- map["country"]
    }
}
class WeatherListMainResponce : Mappable {
    
    var temp = Double()

    required init?(map: Map) { }

    func mapping(map: Map) {
        temp <- map["temp"]
        
    }
}
class WeatherListWeatherResponce : Mappable {
    
    var main = String()

    required init?(map: Map) { }

    func mapping(map: Map) {
        
        main <- map["main"]
        
    }
}

