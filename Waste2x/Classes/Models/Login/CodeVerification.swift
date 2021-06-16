//
//  CodeVerification.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 09/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper
typealias CodeVerificationCompletionHandler = (_ data: CodeVerification?, _ error: Error?, _ status: Int?, _ message:String) -> Void
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
                if let data = Mapper<CodeVerification>().map(JSON: newResult as [String : Any]) {
                    completion(data, nil, 200,message)
                } else {
                    completion(nil, nil, 201,message)
                }
                
            } else {
                 completion(nil, error, 404,message)
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
