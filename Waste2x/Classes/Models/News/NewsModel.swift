//
//  NewsModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 11/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper

class NewsModel : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<CodeVerificationResponce>().map(JSON: [:])
    var statusCode = [""]

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
}
