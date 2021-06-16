//
//  NewsModel.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro

//

import Foundation
import ObjectMapper
typealias FaqCompletionHandler = (_ data: FaqModel?, _ error: Error?, _ status: Bool?,_ message:String?) -> Void
class FaqModel : Mappable {
    var success = Bool()
    var message = ""
    var result = Mapper<Faq>().map(JSON: [:])
    var statusCode = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        
        success   <- map["success"]
        message <- map["message"]
        result    <- map["result"]
        statusCode  <- map["status_code"]
    }
    
    class func FaqApiFunction(_ completion: @escaping FaqCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.FaqApiFunctionCall(){ result, error, status,message in
            Utility.hideLoading()
            if error == nil {
                let newResult = ["result":result]
                if let data = Mapper<FaqModel>().map(JSON: newResult as [String : AnyObject]) {
                    completion(data, nil, status,message)
                } else {
                    completion(nil, nil, status,message)
                }
                
            } else {
                completion(nil, error, status,message)
            }
        }
    }
}

class Faq : Mappable {
    var faqs = [FaqResult]()
    var other = [OtherResult]()
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        faqs   <- map["faqs"]
        other  <- map["others"]
    }
}

class FaqResult : Mappable {
    var question = ""
    var answer = ""
    var languageId = Int()
    var createdAt = ""
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        question   <- map["question"]
        answer <- map["answer"]
        languageId <- map["language_id"]
        createdAt <- map["created_at"]
    }
}
class OtherResult : Mappable {
    var question = ""
    var answer = ""
    var languageId = Int()
    var createdAt = ""
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        question   <- map["question"]
        answer <- map["answer"]
        languageId <- map["language_id"]
        createdAt <- map["created_at"]
    }
}



