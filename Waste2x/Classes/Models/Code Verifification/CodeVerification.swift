//
//  CodeVerification.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 09/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

class CodeVerification : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<CodeVerificationResponce>().map(JSON: [:])
    var statusCode = [""]

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func verificationCode(phoneNumber: String, _ completion: @escaping ForgotPasswordCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.verificationCode(number: phoneNumber) { result, error, status in
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

class CodeVerificationResponce : Mappable {
    
    var code = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        code <- map["code"]
    }
}
