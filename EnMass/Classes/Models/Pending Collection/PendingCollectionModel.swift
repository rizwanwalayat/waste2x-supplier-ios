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


enum PoRequestStatus : String {
    case notSent = "Not sent"
    case pendingResponse = "Pending Response"
    case denied = "Denied"
    case approved = "Approved"
}

class PendingCollectionModel : Mappable {
    var success = Bool()
    var message = ""
    var result : PendingCollectionResultResponce?
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

class PendingCollectionResultResponce : Mappable
{
    var pendingCollections = [PendingCollectionDataModel]()
    var poRequests = [PendingCollectionDataModel]()
    var deniedPoRequests = [PendingCollectionDataModel]()

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        pendingCollections <- map["pending_collection"]
        poRequests <- map["po_requests"]
        deniedPoRequests <- map["denied_po_requests"]
    }

}

class PendingCollectionDataModel : Mappable {
    
    var history = [PendingCollectionHistory]()
    var id = -1
    var supplier = ""
    var farm = ""
    var address = ""
    var waste_amount = ""
    var sell_waste : Double = 0.0
    var price : Double = 0.0
    var status = ""
    var schedule_type = ""
    var frequency = ""
    var schedule_date = ""
    var po_amount = -1
    var commodity = ""
    var customer_phone = ""
    var notificationId = -1
    var poRequestStatus = ""
    var poRequestStatusType = PoRequestStatus.notSent

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        history <- map["history"]
        id <- map["id"]
        supplier <- map["supplier"]
        farm <- map["farm"]
        address <- map["address"]
        waste_amount <- map["waste_amount"]
        sell_waste <- map["sell_waste"]
        price <- map["price"]
        status <- map["status"]
        schedule_type <- map["schedule_type"]
        frequency <- map["frequency"]
        schedule_date <- map["schedule_date"]
        po_amount <- map["amount"]
        commodity <- map["commodity"]
        customer_phone <- map["customer_phone"]
        notificationId <- map["notification_id"]
        enumHanldingsForStatus(status)
    }
    
    func enumHanldingsForStatus(_ requestResponse : String) {
        
        let statues = [PoRequestStatus.notSent, PoRequestStatus.pendingResponse, PoRequestStatus.denied, PoRequestStatus.approved]
        
        for status in statues {
            if requestResponse == status.rawValue {
                poRequestStatusType = status
                break
            }
            else
            {
                poRequestStatusType = .approved
            }
        }
        
    }

}

class PendingCollectionHistory : Mappable {
    var id = -1
    var pending_collection_id = -1
    var entity_type = ""
    var activityDate = ""
    var status = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        pending_collection_id <- map["pending_collection_id"]
        entity_type <- map["entity_type"]
        activityDate <- map["activityDate"]
        status <- map["status"]
    }

}



//MARK: - Detailed Pending Collection -

class PendingCollectionDetailModel : Mappable {
    var success = Bool()
    var message = ""
    var result : PendingCollectionDataModel?
    var statusCode = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func pendingCollectionApiCall(id: Int, poRequest: Bool, _ completion: @escaping PendingCollectionDetailCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.pendingResponceApiCall(id: id, poRequest: poRequest) { result, error, status, message in
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
    
    
    
    class func acceptRejectShipment(notificationID:Int,notificationResponce:String, _ completion: @escaping NotificationResponceModelCompletionHandler)
    {
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
