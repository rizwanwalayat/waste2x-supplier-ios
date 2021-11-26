
//
//  PaymentModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro

//

import Foundation
import ObjectMapper
typealias PaymentCompletionHandler = (_ data: PaymentModel?, _ error: Error?, _ status: Bool?,_ message:String?) -> Void
class PaymentModel : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<PaymentResult>().map(JSON: [:])
    var statusCode = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }

    class func paymentApiFunction(_ completion: @escaping PaymentCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.PaymentApiCall(){ result, error, status,message in
            
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<PaymentModel>().map(JSON: newResult as [String : AnyObject]) {
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

class PaymentResult : Mappable {
    var accountId = String()
    var email = ""
    var details_submitted = Bool()
    var payout = Bool()
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        accountId   <- map["account_id"]
        email <- map["email"]
        details_submitted    <- map["details_submitted"]
        payout  <- map["payout"]
    }
}

