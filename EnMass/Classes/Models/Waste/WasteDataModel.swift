//
//  WasteDataModel.swift
//  Waste2x
//
//  Created by MAC on 16/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper

typealias WasteCompletionHandler = (_ data: WasteDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
typealias WasteDetailImageUploadCompletionHandler = (_ data: WasteDetailImageUploadDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
typealias WasteDetailLocationCompletionHandler = (_ data: WasteDetailLocationDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void

class WasteDataModel : Mappable
{
    var success = false
    var status_code = -1
    var message = ""
    var result : WasteDetialResult?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
        result <- map["result"]
    }
    
    
    class func fetchWasteDetail(params : [String:AnyObject], _ completion: @escaping WasteCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchWasteDetailData(params: params, { result, error, success, message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<WasteDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, success,message)
                } else {
                    completion(nil, nil, success,message)
                }
                
            } else {
                 completion(nil, error, success,message)
            }
        })
    }
    
    
    class func uploadImage(params : [String:AnyObject], _ completion: @escaping WasteDetailImageUploadCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.saveWasteimages(params: params, { result, error, success, message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<WasteDetailImageUploadDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, success,message)
                } else {
                    completion(nil, nil, success,message)
                }
                
            } else {
                 completion(nil, error, success,message)
            }
        })
    }
    
    class func updateWasteSize(params : [String:AnyObject], _ completion: @escaping WasteDetailImageUploadCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.updateWasteSize(params: params, { result, error, success, message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<WasteDetailImageUploadDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, success,message)
                } else {
                    completion(nil, nil, success,message)
                }
                
            } else {
                 completion(nil, error, success,message)
            }
        })
    }
    
    class func updateWasteLocation(params : [String:AnyObject], _ completion: @escaping WasteDetailLocationCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.updateWasteLocation(params: params, { result, error, success, message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<WasteDetailLocationDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, success,message)
                } else {
                    completion(nil, nil, success,message)
                }
                
            } else {
                 completion(nil, error, success,message)
            }
        })
    }
    
}
