//
//  ChatMessagesViewModel.swift
//  Waste2x
//
//  Created by MAC on 18/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import TwilioChatClient


// MARK: - Twillio Chat Messages Handlings
extension ChatMessagesViewController{
    
    func loginToTwillio()
    {
        TwillioChatDataModel.shared.delegate = self
        MessagesDataModel.fetchTwillioAccessToken() { dataResponse, error, success, message  in
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if dataResponse != nil {
                
                if let isSuccess = success {
                    
                    if isSuccess {
                        
                        if let token = dataResponse?.result?.access_token {
                            
                            TwillioChatDataModel.shared.loginToTwillio(with: token)
                    
                        }
                    }
                    else
                    {
                        Utility.showAlertController(self, "Failed!, \(message)")
                    }
                    
                }
                else
                {
                    Utility.showAlertController(self, "Failed!, \(message)")
                }
            }
        }
    }
    
    private func refreshAccessToken() {
        
        MessagesDataModel.fetchTwillioAccessToken() { dataResponse, error, success, message  in
            
            guard dataResponse != nil else {
               print("Error retrieving token: \(error.debugDescription)")
               return
           }
            if let isSuccess = success {
                
                if isSuccess {
                    
                    if let token = dataResponse?.result?.access_token {
                        TwillioChatDataModel.shared.loginToTwillio(with: token)
                
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
        tableViewMessages.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
}


extension ChatMessagesViewController : TwillioChatDataModelDelegate
{
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
        
        refreshAccessToken()
    }
    
    
    
}
