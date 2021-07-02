//
//  NotificationResponceModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 17/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper
typealias NotificationResponceModelCompletionHandler = (_ data: NotificationResponceModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
class NotificationResponceModel : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<NotificationResponceResult>().map(JSON: [:])
    var status_code = [""]

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        status_code  <- map["status_code"]
    }
    
    class func NotificationResponceModelApiFunction(notificationID:Int,notificationResponce:String, _ completion: @escaping NotificationResponceModelCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.notifiationResponceApiCall(id:notificationID,responce: notificationResponce) { result, error, status,message in
            Utility.hideLoading()
            
            if error == nil {
                let newResult = ["result" : result]
                if let data = Mapper<NotificationResponceModel>().map(JSON: newResult as [String : AnyObject]) {
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
class NotificationResponceResult : Mappable {
    var success = Bool()


    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]

    }

}
