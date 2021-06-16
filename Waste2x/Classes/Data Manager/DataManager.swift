//
//  DataManager.swift
//  Doro
//
//  Created by a on 27/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

class DataManager {
    
    static let shared = DataManager()
    

    func setStringData (value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func setIntData (value: Int, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func setFinger (enable: Bool) {
        UserDefaults.standard.set(enable, forKey: "finger")
    }
    
    func getFinger () -> Bool {
        var enabled = false

        if UserDefaults.standard.object(forKey: "finger") != nil {
            enabled = UserDefaults.standard.bool(forKey: "finger")
        }
        return enabled
    }
    
    func deleteFinger () {
         UserDefaults.standard.set(nil, forKey: "finger")
    }
    
    func setUser (user: String) {
        UserDefaults.standard.set(user, forKey: "user_data")
    }
    
    func getUser() -> Registration? {
        var user: Registration?

        if UserDefaults.standard.object(forKey: "user_data") != nil {
            user = Mapper<Registration>().map(JSONString:UserDefaults.standard.string(forKey: "user_data")!)
        }
        return user
    }
    func deleteUser () {
         UserDefaults.standard.set(nil, forKey: "user_data")
        
    }
    func setWeather (weather: String) {
        UserDefaults.standard.set(weather, forKey: "weather")
    }
    
    func getWeather() -> WeatherAPI? {
        var weather: WeatherAPI?

        if UserDefaults.standard.object(forKey: "weather") != nil {
            weather = Mapper<WeatherAPI>().map(JSONString:UserDefaults.standard.string(forKey: "weather")!)
        }
        return weather
    }
    
    

    
    func setAuthentication (auth: String) {
        UserDefaults.standard.set(auth, forKey: "auth_data")
    }
    
    func getAuthentication() -> String {
        var token: String?

        if UserDefaults.standard.string(forKey: "AccessToken") != nil {
            token = UserDefaults.standard.string(forKey: "AccessToken")!
        }
        return token!
    }
    
    func deleteAuthentication () {
        UserDefaults.standard.set(nil, forKey: "auth_data")
    }
    
    
    func setFavoriteId (id: Int) {
        var newItem: [Int] = []
        var filterData: [Int] = []
        //getFavoriteIds()
        if getFavoriteIds() != nil && getFavoriteIds()!.count != 0 {
            newItem = getFavoriteIds()!
            filterData = filterData.filter({$0 == id})
        }
        
        if filterData.count == 0 {
            newItem.append(id)
        }
        UserDefaults.standard.set(newItem, forKey: "fav_data")
    }
    
    func getFavoriteIds() -> [Int]? {
        var items: [Int]?
        
        if UserDefaults.standard.array(forKey: "fav_data") != nil {
            items = UserDefaults.standard.array(forKey: "fav_data") as? [Int]
        }
        return items
    }
    
}
