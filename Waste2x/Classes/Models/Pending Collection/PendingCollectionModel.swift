//
//  PendingCollectionModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 18/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper
typealias PendingCollectionCompletionHandler = (_ data: PendingCollectionModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
typealias PendingCollectionDetailCompletionHandler = (_ data: PendingCollectionDetailModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
class PendingCollectionModel : Mappable {
    var success = Bool()
    var message = ""
    var result = [PendingCollectionResultResponce]()
    var statusCode = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func pendingCollectionApiCall(_ completion: @escaping PendingCollectionCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.pendingCollectionApiFunctionCall{ result, error, status,message in
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<PendingCollectionModel>().map(JSON: newResult as [String : AnyObject]) {
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

class PendingCollectionResultResponce : Mappable {

    var id = Int()
    var supplierNumber = ""
    var pendingCollection = ""
    var farm = ""
    var wasteAmount = Double()
    var sellWaste = ""
    var price = Double()
    var status = ""
    var schedule_type = ""
    var frequency = ""
    var scheduleDate = ""
    var address = ""
    var history = [PendingCollectionResultHistory]()

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        pendingCollection <- map["pending_collections"]
        supplierNumber <-    map["supplier"]
        farm <- map["farm"]
        wasteAmount <- map["waste_amount"]
        sellWaste <- map["sell_waste"]
        price <- map["price"]
        status <- map["status"]
        schedule_type <- map["schedule_type"]
        frequency <- map["frequency"]
        scheduleDate <- map["schedule_date"]
        address <- map["address"]
        history <- map["history"]
        
        
    }
}
class PendingCollectionResultHistory : Mappable {

    var id = Int()
    var pendingCollectionId = Int()
    var activityDate = ""
    var status = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        pendingCollectionId <- map["pending_collection_id"]
        activityDate <-    map["activityDate"]
        status <- map["status"]
        
        
    }
}

//MARK: - Detailed Pending Collection

class PendingCollectionDetailModel : Mappable {
    var success = Bool()
    var message = ""
    var result = [PendingCollectionResultResponce]()
    var statusCode = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func pendingCollectionApiCall(id: Int, _ completion: @escaping PendingCollectionDetailCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.pendingResponceApiCall(id: id) { result, error, status, message in
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<PendingCollectionDetailModel>().map(JSON: newResult as [String : AnyObject]) {
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
