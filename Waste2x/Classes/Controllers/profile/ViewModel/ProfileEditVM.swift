//
//  ProfileEditVM.swift
//  CarrierApp
//
//  Created by Phaedra Solutions  on 21/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

typealias ProfileEditCompletionHandler = (_ data: UserDetailDataModel?, _ error: Error?, _ status: Bool?,_ message:String) -> Void

import Foundation
import UIKit
import ObjectMapper

class ProfileEditVM: NSObject {
    var userName: String?
    var userEmail: String?
    var userPhone: String?
    var userImage: String?
    
    func getUserData(){
        
        guard let user = DataManager.shared.getUserDetail() else {return}
        userName = user.name
        userEmail = user.email
        userPhone = user.phone
        userImage = user.image
    }

    func editUserName(newName: String, _ completionHandler: @escaping ProfileEditCompletionHandler){
        
        Utility.showLoading()
        APIClient.shared.updateUserName(userName: newName) { result, error, success, message in
            
            Utility.hideLoading()
            
            if success, error == nil {
                let newResult = ["result" : result]
                if let data = Mapper<UserDetailDataModel>().map(JSON: newResult as [String : Any]) {
                    completionHandler(data, nil, success, message)
                }
                else {
                    completionHandler(nil, nil, false, message)
                }
            } else {
                completionHandler(nil, error, success, message)
            }
        }
    }
    
    func uploadImage(_ image : UIImage, _ completionHandler: @escaping ProfileEditCompletionHandler){
        
        Utility.showLoading()
        APIClient.shared.saveUserImage(image: image) { result, error, success, message in
            
            Utility.hideLoading()
            
            if success, error == nil {

                let newResult = ["result" : result]
                if let data = Mapper<UserDetailDataModel>().map(JSON: newResult as [String : Any]) {
                    completionHandler(data, nil, success, message)
                }
                else {
                    completionHandler(nil, nil, false, message)
                }
            } else {
                completionHandler(nil, error, success, message)
            }
        }
    }
}
