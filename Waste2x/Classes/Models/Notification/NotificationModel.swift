//
//  notificationVerification.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 09/06/2021.
//  Copyright © 2021 notificationsrbit. All rights reserved.
//

import Foundation
import ObjectMapper
typealias NotificationCompletionHandler = (_ data: NotificationModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
class NotificationModel : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<NotificationResult>().map(JSON: [:])
    var status_code = [""]

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        status_code  <- map["status_code"]
    }
    
    class func notificationApiFunction(_ completion: @escaping NotificationCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.notificationApiCall { result, error, status,message in
            Utility.hideLoading()
            
            if error == nil {
                let newResult = ["result" : result]
                if let data = Mapper<NotificationModel>().map(JSON: newResult as [String : AnyObject]) {
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

class NotificationResult : Mappable {
    
    var notifications = [NotificationResultList]()

    required init?(map: Map) { }

    func mapping(map: Map) {
        notifications <- map["notifications"]
    }
}
class NotificationResultList : Mappable {
    
    var idd = Int()
    var title = ""
    var message = ""
    var response = ""
    var createdAt = ""
    var pendingCollectionId = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {
        idd <- map["id"]
        title <- map["title"]
        message <- map["message"]
        response <- map["response"]
        createdAt <- map["created_at"]
        pendingCollectionId <- map["pending_collection_id"]
        
    }
}
