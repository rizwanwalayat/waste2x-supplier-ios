//
//  NewsModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 11/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper
typealias NewsCompletionHandler = (_ data: NewsModel?, _ error: Error?, _ status: Int?, _ message:String) -> Void
class NewsModel : Mappable {
    var success = Bool()
    var message = ""
    var result = [NewsResult]()
    var statusCode = Int()

    required init?(map: Map) { }

    func mapping(map: Map) {

        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func NewsApiCall(_ completion: @escaping NewsCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.NewsApiCall{ result, error, status,message in
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<NewsModel>().map(JSON: newResult as [String : AnyObject]) {
                    completion(data, nil, 200,message)
                } else {
                    completion(nil, nil, 201,message)
                }
                
            } else {
                 completion(nil, error, 404,message)
            }
        }
    }
}



class NewsResult : Mappable {
    var type = ""
    var title = ""
    var description = ""
    var fileUrl = ""
    var date_published = ""
    var picture = ""


    required init?(map: Map) { }

    func mapping(map: Map) {

        type   <- map["type"]
        title <- map["title"]
        description    <- map["description"]
        fileUrl  <- map["file_url"]
        date_published <- map["date_published"]
        picture  <- map["picture"]
    }
}
