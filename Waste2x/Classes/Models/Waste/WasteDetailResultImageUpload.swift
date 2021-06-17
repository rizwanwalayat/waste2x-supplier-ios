//
//  WasteDetailResultImageUpload.swift
//  Waste2x
//
//  Created by MAC on 17/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

class WasteDetailImageUploadDataModel : Mappable
{
    var message = ""
    var percentage = ""
    var starsEarned = ""
    var starRedeem = ""
    var statusCode = ""
    var success = false
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        percentage <- map["percentage"]
        starsEarned <- map["stars_earned"]
        starRedeem <- map["stars_redeemed"]
        statusCode <- map["status_code"]
        success <- map["success"]
    }
}
