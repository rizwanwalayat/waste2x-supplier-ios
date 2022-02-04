//
//  InvoicesVM.swift
//  EnMass App
//
//  Created by Phaedra Solutions  on 09/08/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import ObjectMapper

typealias InvoicesCompletionHandler = (_ data: InvoicesModel?, _ error: Error?, _ status: Bool?, _ message: String) -> Void
class InvoicesVM: NSObject {
    var data: InvoicesModel?
    
    override init(){
        super.init()
    }

    func fetchInvoicesData(_ completionhandler: @escaping InvoicesCompletionHandler) {
        Utility.showLoading()
        APIClient.shared.fetchInvoicesApi { result, error, status, message in
            Utility.hideLoading()
            
            let newResult = ["result": result, "error": error, "status": status, "message": message ] as [String : Any]
            
            if status, error == nil, let data = Mapper<InvoicesModel>().map(JSON: newResult) {
                self.data = data
                completionhandler(data, error, status, message)
            } else {
                completionhandler(nil, error, status, message)
            }
            
        }
    }
}
