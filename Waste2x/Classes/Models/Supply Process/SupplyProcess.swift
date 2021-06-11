//
//  SupplyProcess.swift
//  Waste2x
//
//  Created by MAC on 10/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper


class SupplyProcessDataModel : Mappable {
    
    var success = Bool()
    var message = ""
    var result = Mapper<CodeVerificationResponce>().map(JSON: [:])
    var statusCode = [""]
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    
    class func fetchSupplyProcessData(_ completion: @escaping ForgotPasswordCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchSupplyProcessData { result, error, statusCode in
            
            Utility.hideLoading()
            if error == nil {
                
                print(result)
//                if let data = Mapper<CodeVerification>().map(JSON: result as! [String : Any]) {
//                    completion(data, nil, 200)
//                } else {
//                    completion(nil, nil, 201)
//                }
                
            } else {
                completion(nil, error, 404)
            }
        }
    }
}
