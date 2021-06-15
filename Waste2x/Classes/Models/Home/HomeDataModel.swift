//
//  HomeDataModel.swift
//  Waste2x
//
//  Created by MAC on 14/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper


typealias HomeFetchFarmsCompletionHandler = (_ data: HomeFetchFarmsDataModel?, _ error: Error?, _ status: Int?) -> Void


class HomeFetchFarmsDataModel : Mappable
{
    
    
    var success = false
    var status_code = -1
    var message = ""
    var result : HomeResultDataModel?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
        result <- map["result"]
    }
    
    
    class func fetchSites( _ completion: @escaping HomeFetchFarmsCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchSitesForHomeData( { response, error, code in
            
            Utility.hideLoading()
            
            if response != nil {
                
                let newResult  = ["result" : response!]
                if let data = Mapper<HomeFetchFarmsDataModel>().map(JSON: newResult as [String : Any] ) {
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
