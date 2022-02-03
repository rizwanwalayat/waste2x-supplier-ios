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
    var result = [InvoicesResult]()
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        result <- map["result"]
    }
}

class InvoicesResult: Mappable {
    var id = 0
    var status = ""
    var total = 0.0
    var unit = ""
    var shipments = [InvoicesShipment]()

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        status <- map["status"]
        total <- map["total"]
        unit <- map["unit"]
        shipments <- map["shipments"]
    }
    
   
}

class InvoicesShipment: Mappable {
    var date = ""
    var subtotal = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        date <- map["date"]
        subtotal <- map["subtotal"]
        
    }
    
}
