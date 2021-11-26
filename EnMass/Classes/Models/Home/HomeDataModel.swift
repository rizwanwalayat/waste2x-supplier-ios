//
//  HomeDataModel.swift
//  Waste2x
//
//  Created by MAC on 14/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import ObjectMapper


typealias HomeFetchFarmsCompletionHandler = (_ data: HomeFetchFarmsDataModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void


class HomeFetchFarmsDataModel : Mappable
{
    
    
    var success = false
    var status_code = -1
    var message = ""
    var pendingCollection = Bool()
    var result : HomeResultDataModel?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
        pendingCollection  <- map["pending_collection"]
        result <- map["result"]
    }
    
    
    class func fetchSites( _ completion: @escaping HomeFetchFarmsCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchSitesForHomeData( { response, error, status,message in
            Utility.hideLoading()
            
            if response != nil {
                
                let newResult  = ["result" : response!]
                if let data = Mapper<HomeFetchFarmsDataModel>().map(JSON: newResult as [String : Any] ) {
                    completion(data, nil, status,message)
                } else {
                    completion(nil, nil, status,message)
                }
                
            } else {
                completion(nil, error, status,message)
            }
        })
    }
}

class FetchSitesCustomModel : NSObject
{
    var farmName = ""
    var farmId = -1
    var cropType = ""
    var cropTypeId = -1
    var cropTypeImage = ""
    var sharedIconUrl = ""
    var completeCropType = ""
    
    init(_ farmName : String, _ farmId : Int, _ cropType : String, _ cropTypeId : Int, _ cropTypeImage : String, _ completeCropName : String) {
        
        self.farmName = farmName
        self.farmId = farmId
        self.cropType = cropType
        self.cropTypeId = cropTypeId
        self.cropTypeImage = cropTypeImage
        self.completeCropType = completeCropName
    }
}
