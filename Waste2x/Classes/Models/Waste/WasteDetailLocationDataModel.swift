//
//  WasteDetailLocationDataModel.swift
//  Waste2x
//
//  Created by MAC on 23/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper


class WasteDetailLocationDataModel : Mappable {
    var success = true
    var status_code = -1
    var message = ""
    var result = ""

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        success <- map["success"]
        status_code <- map["status_code"]
        message <- map["message"]
        result <- map["result"]
    }

}
