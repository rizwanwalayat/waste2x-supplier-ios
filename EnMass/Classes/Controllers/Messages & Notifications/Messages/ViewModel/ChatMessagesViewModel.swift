//
//  ChatMessagesViewModel.swift
//  Waste2x
//
//  Created by MAC on 18/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import TwilioChatClient
import UIKit


// MARK: - Twillio Chat Messages Handlings
extension ChatMessagesViewController{
    
    func loginToTwillio(identity: String)
    {
        Utility.showLoading()

        TwillioChatDataModel.shared.delegate = self
        MessagesDataModel.fetchTwillioAccessToken(identity: identity) { dataResponse, error, success, message  in
            
            if error != nil
            {
                
                Utility.showAlertController(self, error!.localizedDescription)
                Utility.hideLoading()
            }
            
            if dataResponse != nil {
                
                if let isSuccess = success {
                    
                    if isSuccess {
                        
                        if let token = dataResponse?.result?.access_token {
                            
                            TwillioChatDataModel.shared.loginToTwillio(with: token, identity: identity)
                        }
                    }
                    else
                    {
                        Utility.showAlertController(self, "Failed!, \(message)")
                        Utility.hideLoading()

                    }
                    
                }
                else
                {
                    Utility.showAlertController(self, "Failed!, \(message)")
                    Utility.hideLoading()

                }
            }
        }
    }
    
    private func refreshAccessToken(identity: String) {
        
        MessagesDataModel.fetchTwillioAccessToken(identity: identity) { dataResponse, error, success, message  in
            
            guard dataResponse != nil else {
               print("Error retrieving token: \(error.debugDescription)")
               return
           }
            if let isSuccess = success {
                
                if isSuccess {
                    
                    if let token = dataResponse?.result?.access_token {
                        TwillioChatDataModel.shared.loginToTwillio(with: token, identity: identity)
                
                    }
                }
                else
                {
                    Utility.showAlertController(self, "Failed!, \(message)")
                }
                
            }
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
        }
    }
    
    private func scrollToBottomMessage()
    {
        if TwillioChatDataModel.shared.messages.count == 0 {
            return
        }
        
        let bottomMessageIndex = IndexPath(row: 0,
                                           section: 0)
        tableViewMessages.scrollToRow(at: bottomMessageIndex, at: .top, animated: true)
    }
    
    func showFileProgressLoader(_ flag: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.fileProgressView.isHidden = !flag
            self.fileProgressViewHeight.constant = flag ? 50 : 0
            self.view.layoutIfNeeded()
        }
       

    }
}


extension ChatMessagesViewController : TwillioChatDataModelDelegate
{
    func fileUploadStarted() {
        fileProgressBar.setProgress(0.1, animated: false)
        showFileProgressLoader(true)
    }
    
    func fileUploadProgress(totalBytes: Int, sentBytes: Int) {
        let progress: Float = Float(sentBytes) / Float(totalBytes)
        fileProgressBar.setProgress(progress, animated: true)
    }
    
    func fileUploadCompleted() {
        fileProgressBar.setProgress(1.0, animated: true)
        showFileProgressLoader(false)
    }
    
   
    func failedToConnect() {
    }
    
    func connectCompleted() {
    }
    
    func reloadAllMessages() {
        
        self.tableViewMessages.reloadData()
    }
    
    func receivedNewMessage() {
        
        scrollToBottomMessage()
    }
    
    func tokeExpired() {
        
//        refreshAccessToken()
    }
    
    
    
}
