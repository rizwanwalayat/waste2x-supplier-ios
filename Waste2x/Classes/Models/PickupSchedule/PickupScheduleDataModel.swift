//
//  PickupScheduleDataModel.swift
//  Waste2x
//
//  Created by MAC on 16/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper


typealias PickupScheduleCompletionHandler = (_ data: PickupScheduleDataModel?, _ error: Error?, _ status: Int?) -> Void


class PickupScheduleDataModel : Mappable
{
    var success = false
    var status_code = -1
    var message = ""
    var result : ResultSiteCreation?

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
        APIClient.shared.postSupplyProcessData(params: params, { response, error, code in
            
            Utility.hideLoading()
            
            if response != nil {
                
                let newResult  = ["result" : response!]
                if let data = Mapper<PickupScheduleDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, 200)
                } else {
                    completion(nil, nil, 201)
                }
                
            } else {
                completion(nil, error, 404)
            }
        })
    }

}
