//
//  DispatchesModel.swift
//  CarrierApp
//
//  Created by Phaedra Solutions  on 09/08/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

class InvoicesModel: Mappable {
    var success = false
    var status_code = -1
    var message = ""
    var result: InvoicesResult?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        result <- map["result"]
    }
    

}

class InvoicesResult: Mappable {
    var array: [[InvoicesResultItem]] = []
    var scheduled = [InvoicesResultItem]()
    var in_transit = [InvoicesResultItem]()
    var delivered = [InvoicesResultItem]()
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        scheduled <- map["scheduled"]
        in_transit <- map["in_transit"]
        delivered <- map["delivered"]
        postMapping()
    }
    
    func postMapping(){
        array.insert(scheduled, at: 0)
        array.insert(in_transit, at: 1)
        array.insert(delivered, at: 2)
    }
}

class InvoicesResultItem: Mappable {
    
    var id: Int
    var date_created: String
    var pick_up: String
    var drop_off: String
    var dispatch_rep: String
    var commodity : String
    var deliveryDate : String
    var weight : String
    
    required init?(map: Map) {
        id = 0
        date_created = ""
        pick_up = ""
        drop_off = ""
        dispatch_rep = ""
        commodity = ""
        deliveryDate = ""
        weight = ""
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        date_created <- map["date_created"]
        pick_up <- map["pick_up"]
        drop_off <- map["drop_off"]
        dispatch_rep <- map["dispatch_rep"]
        commodity <- map["commodity"]
        deliveryDate <- map["delivery_date"]
        weight <- map["weight"]
    }
    
}
