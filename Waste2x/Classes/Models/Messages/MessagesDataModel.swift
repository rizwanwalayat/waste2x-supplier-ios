//
//  MessagesDataModel.swift
//  Waste2x
//
//  Created by MAC on 18/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

typealias MessagesCompletionHandler = (_ data: MessagesDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void


class MessagesDataModel : Mappable
{
    var success = false
    var status_code = -1
    var message = ""
    var result : MessageResult?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
        result <- map["result"]
    }
    
    
    class func fetchTwillioAccessToken(params : [String:AnyObject], _ completion: @escaping MessagesCompletionHandler) {
        
        Utility.showLoading()
        APIClient.shared.fetchTwillioAccessToken(params: params, { result, error, success, message in
            
            Utility.hideLoading()
            
            if result != nil {
                
                let newResult  = ["result" : result!]
                if let data = Mapper<MessagesDataModel>().map(JSON: newResult as [String : Any] ) {
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
