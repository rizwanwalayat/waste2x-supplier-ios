//
//  DataManager.swift
//  Haid3r
//
//  Created by a on 27/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper

class DataManager {
    
    static let shared = DataManager()
    

    func setWasteType (value : String)
    {
        UserDefaults.standard.set(value, forKey: "crop_type")
    }
    
    func setUserEmail (value : String)
    {
        UserDefaults.standard.set(nil, forKey: "user_email")
        UserDefaults.standard.set(value, forKey: "user_email")
    }
    
    func setStringData (value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func setIntData (value: Int, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    func setBoolData (value: Bool, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func setFinger (enable: Bool) {
        UserDefaults.standard.set(enable, forKey: "finger")
    }
    
    func setUser (user: String) {
        UserDefaults.standard.set(user, forKey: "user_data")
    }
    
    func setIfUserLoggedInSuccessFully()
    {
        UserDefaults.standard.set(true, forKey: "user_Loggedin")
    }
    
    func setIfUserLoggedOutSuccessFully()
    {
        UserDefaults.standard.set(false, forKey: "user_Loggedin")
    }
    
    func setFaq (user: String) {
        UserDefaults.standard.set(user, forKey: "faq")
    }
    
    func setWeather (weather: String) {
        UserDefaults.standard.set(weather, forKey: "weather")
    }
    
    func setAuthentication (auth: String) {
        UserDefaults.standard.set(auth, forKey: "auth_data")
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
    
    func saveUsersDetail(_ userDetailJsonString: String)
    {
        UserDefaults.standard.set(userDetailJsonString, forKey: "user_Detail")
    }
        
}

// MARK: - get Detials
extension DataManager {
    
    
    func getFavoriteIds() -> [Int]? {
        var items: [Int]?
        
        if UserDefaults.standard.array(forKey: "fav_data") != nil {
            items = UserDefaults.standard.array(forKey: "fav_data") as? [Int]
        }
        return items
    }
    
    
    func getAuthentication() -> String {
        var token: String?

        if UserDefaults.standard.string(forKey: "AccessToken") != nil {
            token = UserDefaults.standard.string(forKey: "AccessToken")!
        }
        return token!
    }
    
    func getWeather() -> WeatherAPI? {
        var weather: WeatherAPI?

        if UserDefaults.standard.object(forKey: "weather") != nil {
            weather = Mapper<WeatherAPI>().map(JSONString:UserDefaults.standard.string(forKey: "weather")!)
        }
        return weather
    }
    
    func getFaq() -> FaqModel? {
        var faq: FaqModel?

        if UserDefaults.standard.object(forKey: "faq") != nil {
            faq = Mapper<FaqModel>().map(JSONString:UserDefaults.standard.string(forKey: "faq")!)
        }
        return faq
    }
    
    func getUser() -> Registration? {
        var user: Registration?

        if UserDefaults.standard.object(forKey: "user_data") != nil {
            user = Mapper<Registration>().map(JSONString:UserDefaults.standard.string(forKey: "user_data")!)
        }
        return user
    }
    
    func isUserLoggedIn() -> Bool {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "user_Loggedin")
        return isUserLoggedIn
    }
    
    func getFinger () -> Bool {
        var enabled = false

        if UserDefaults.standard.object(forKey: "finger") != nil {
            enabled = UserDefaults.standard.bool(forKey: "finger")
        }
        return enabled
    }
    
    func getBoolData(key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func getWasteType () -> String
    {
        var type = ""
        if UserDefaults.standard.string(forKey: "crop_type") != nil {
            type = UserDefaults.standard.string(forKey: "crop_type")!
        }
        return type
    }
    
    func getUserEmail() -> String
    {
        if let email = UserDefaults.standard.string(forKey: "user_email"){
            return email
        }
        else
        {
            return ""
        }
    }
    
    func getUserDetail() -> UserDetailResult?
    {
        var user: UserDetailResult?

        if UserDefaults.standard.object(forKey: "user_Detail") != nil {
            user = Mapper<UserDetailResult>().map(JSONString:UserDefaults.standard.string(forKey: "user_Detail")!)
        }
        return user
    }
}


// MARK: - Remove/ Delete
extension DataManager {
    
    func deleteAuthentication () {
        UserDefaults.standard.set(nil, forKey: "auth_data")
    }
    
    func deleteFaq () {
         UserDefaults.standard.set(nil, forKey: "faq")
    }
    
    func deleteUser () {
         UserDefaults.standard.set(nil, forKey: "user_data")
        
    }
    
    func deleteFinger () {
         UserDefaults.standard.set(nil, forKey: "finger")
    }
    
    func deleteUserDetial()
    {
        UserDefaults.standard.set(nil, forKey: "user_Detail")
    }
}
