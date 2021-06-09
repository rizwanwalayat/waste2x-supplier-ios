//
//  CodeVerification.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 09/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

class Registration : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<RegistrationResult>().map(JSON: [:])
    var statusCode = [""]

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func verificationCode(phone: String,code: String,latitude: Double,longitude: Double,firebase_token: String,phone_imei: Int,phone_os: String,phone_model: String, _ completion: @escaping RegistrationCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.userRegistration(phone: phone, code: code, latitude: latitude, longitude: longitude, firebase_token: firebase_token, phone_imei: phone_imei, phone_os: phone_os, phone_model: phone_model) { result, error, status in
            Utility.hideLoading()
            if error == nil {
        
                if let data = result as AnyObject? {
                    completion(data, nil, 200)
                    
                } else {
                    completion(nil, nil, 201)
                }
                
            } else {
                 completion(nil, error, 404)
            }
        }
    }
    class func emailVerification(email: String, _ completion: @escaping EmailRegistrationCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.emailVerification(email: email) { result, error, status in
            Utility.hideLoading()
            if error == nil {
        
                if let data = result as AnyObject? {
                    completion(data, nil, 200)
                    
                } else {
                    completion(nil, nil, 201)
                }
                
            } else {
                 completion(nil, error, 404)
            }
        }
    }
    

}

class RegistrationResult : Mappable {
    
    var code = ""
    var isNewUser = Bool()
    var stripe_account_name = ""
    var waste_id = Int()
    var auth_token = ""
    var waste_types = Mapper<WasteTypes>().map(JSON: [:])
    var farm_exist = Bool()
    var farmer_medals = Double()
    var stars_earned = Double()
    var percentage = Double()
    var email = ""
    var phone = ""
    
    required init?(map: Map) { }

    func mapping(map: Map) {
        code <- map["code"]
        isNewUser <- map["is_new_user"]
        stripe_account_name <- map["stripe_account_name"]
        waste_id <- map["waste_id"]
        auth_token <- map["auth_token"]
        waste_types <- map["waste_types"]
        farm_exist <- map["farm_exist"]
        farmer_medals <- map["farmer_medals"]
        stars_earned <- map["stars_earned"]
        percentage <- map["percentage"]
        email <- map["email"]
        phone <- map["phone"]
    }
}


class WasteTypes : Mappable {
    

    required init?(map: Map) { }

    func mapping(map: Map) {

    }
}
