//
//  PickupScheduleDataModel.swift
//  Waste2x
//
//  Created by MAC on 16/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper


typealias PickupScheduleCompletionHandler = (_ data: PickupScheduleDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void


class PickupScheduleDataModel : Mappable
{
    var success = false
    var status_code = -1
    var message = ""
    var result : ResultPickupSchedule?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
        result <- map["result"]
    }
    
    
    class func postPickupScheduleData(params : [String : AnyObject], _ completion: @escaping PickupScheduleCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.postPickupScheduleData(params: params, { response, error, success, message in
    
            Utility.hideLoading()
            
            if response != nil {
                
                let newResult  = ["result" : response!]
                if let data = Mapper<PickupScheduleDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, success, message)
                } else {
                    completion(nil,  nil, success, message)
                }
                
            } else {
                completion(nil, error, success, message)
            }
        })
    }

}



class ResultPickupSchedule : Mappable
{
    var success = Bool()
    var status_code = -1
    var message = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
    }
}
