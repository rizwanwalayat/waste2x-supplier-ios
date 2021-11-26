//
//  CreatePayment.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 16/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper
typealias CreatePaymentCompletionHandler = (_ data: CreatePaymentModel?, _ error: Error?, _ status: Bool?,_ message:String?) -> Void
class CreatePaymentModel : Mappable {
    var success = Bool()
    var message = ""
    var result = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
    }
    class func CreatePaymentApiFunction(_ completion: @escaping CreatePaymentCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.createPaymentApiCall(){ result, error, status,message in
            
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<CreatePaymentModel>().map(JSON: newResult as [String : AnyObject]) {
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
