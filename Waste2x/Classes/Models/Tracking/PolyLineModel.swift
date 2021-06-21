//
//  PolyLine.swift
//  Waste2x
//
//  Created by HaiDer's Macbook Pro on 21/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper
typealias PolyLineCompletionHandler = (_ data: PolyLineAPIModel?, _ error: Error?, _ status: Bool?, _ message:String) -> Void
class PolyLineAPIModel : Mappable {
    var routes = [PolyLineLegs]()
    var status = ""

    required init?(map: Map) { }

    func mapping(map: Map) {

        routes   <- map["routes"]
        status <- map["status"]
        
    }
    
    class func PolyLineAPICall(_ completion: @escaping PolyLineCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.googleLocationPolyLineAPi{ result, error, status,message in
            
            Utility.hideLoading()
            if error == nil {
                if let data = Mapper<PolyLineAPIModel>().map(JSON: result as! [String : Any]) {
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
class PolyLineOverviewPolyline : Mappable {
    var points = ""


    required init?(map: Map) { }

    func mapping(map: Map) {

        points   <- map["points"]
        
    }
}
class PolyLineLegs : Mappable {
    var legs = [PolyLineLegsResult]()
    var overviewPolyline : PolyLineOverviewPolyline?
    var summary = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        overviewPolyline <- map["overview_polyline"]
        summary <- map["summary"]
        legs   <- map["legs"]
    }

}
class PolyLineLegsResult : Mappable {
    var distance : PolyLineLegsResultDistance?
    var duration : PolyLineLegsResultDuration?
    var end_address = ""
    var start_address = ""
    var start_location = ""

    required init?(map: Map) { }

    func mapping(map: Map) {

        distance   <- map["distance"]
        duration   <- map["duration"]
        end_address   <- map["end_address"]
        start_address   <- map["start_address"]
        distance   <- map["distance"]
    }

}
class PolyLineLegsResultDistance : Mappable {
    var text = ""
    var value = ""

    required init?(map: Map) { }

    func mapping(map: Map) {

        text   <- map["text"]
        value   <- map["duration"]
    }

}

class PolyLineLegsResultDuration : Mappable {
    var text = ""
    var value = ""

    required init?(map: Map) { }

    func mapping(map: Map) {

        text   <- map["text"]
        value   <- map["duration"]
    }

}
