//
//  ContactSendModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 24/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper


typealias ContactSendCompletionHandler = (_ data: ContactSendModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
typealias ContactFetchCompletionHandler = (_ data: ContactFetchModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void

//MARK: - Contact Send
class ContactSendModel : Mappable {
    var success = Bool()
    var message = ""
    var result : ContactSendModelResult?
    var statusCode = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func contactSendApiCall(name:String,number:String, _ completion: @escaping ContactSendCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.contactSendApiFunctionCall(name: name, number: number) { result, error, status, message in
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<ContactSendModel>().map(JSON: newResult as [String : AnyObject]) {
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
class ContactSendModelResult : Mappable {
    var inviteId = Int()
    var inviteTo = String()

    required init?(map: Map) { }

    func mapping(map: Map) {

        inviteId   <- map["invite_id"]
        inviteTo <- map["invite_to"]
    }
}

//MARK: - Contact Fetch
class ContactFetchModel : Mappable {
    var success = Bool()
    var message = ""
    var result = [ContactFetchModelResult]()
    var statusCode = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    

    }
    class func contactFetchApiCall( _ completion: @escaping ContactFetchCompletionHandler){
        Utility.showLoading()
        APIClient.shared.contactFetchApiFunctionCall { result, error, status, message in
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<ContactFetchModel>().map(JSON: newResult as [String : AnyObject]) {
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
class ContactFetchModelResult : Mappable {
    var id = Int()
    var contactName = ""
    var contactNumber = ""
    var createdAt = ""

    required init?(map: Map) { }

    func mapping(map: Map) {

        id   <- map["id"]
        contactName <- map["contact_name"]
        contactNumber  <- map["contact_number"]
        createdAt  <- map["created_at"]
    

    }
}
