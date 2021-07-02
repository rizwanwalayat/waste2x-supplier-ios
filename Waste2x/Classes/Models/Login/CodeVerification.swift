//
//  CodeVerification.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 09/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper
typealias CodeVerificationCompletionHandler = (_ data: CodeVerification?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
class CodeVerification : Mappable {
    var success = Bool()
    var message = ""
    var result = [CodeVerificationResponce]()
    var statusCode = [""]

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func verificationCode(phoneNumber: String, _ completion: @escaping phoneNoCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.verificationCode(number: phoneNumber) { result, error, status,message in
            Utility.hideLoading()
            
            if error == nil {
                let newResult = ["result" : result]
                if let data = Mapper<PhoneNoDataModel>().map(JSON: newResult as [String : Any]) {
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

class CodeVerificationResponce : Mappable {
    
    var verificationCode = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        verificationCode <- map["code"]
    }
}
