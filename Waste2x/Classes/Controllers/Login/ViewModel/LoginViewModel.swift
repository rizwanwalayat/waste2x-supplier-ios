//
//  LoginViewModel.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import Foundation

class LoginViewModel : NSObject {
    
    private var apiService : APIService!
    var loginData : String! {
        didSet {
            self.bindLoginViewModelToController?()
        }
    }
    
    var bindLoginViewModelToController : (() -> ())?
    
    override init() {
        super.init()
        self.apiService = APIService()
        callFuncToGetEmpData()
    }
    
    func callFuncToGetEmpData() {
           self.apiService.apiToGetEmployeeData { (loginData) in
               self.loginData = loginData
           }
    }
}
