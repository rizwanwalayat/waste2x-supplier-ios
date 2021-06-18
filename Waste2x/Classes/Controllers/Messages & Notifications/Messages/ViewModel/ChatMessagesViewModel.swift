//
//  ChatMessagesViewModel.swift
//  Waste2x
//
//  Created by MAC on 18/06/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import Foundation
import TwilioChatClient


// MARK: - Twillio Chat Messages Handlings
extension ChatMessagesViewController{
    
    func loginToTwillio()
    {
        let phoneNo = Data?.phone ?? ""
        let params = ["identity" : phoneNo] as [String : AnyObject]
        MessagesDataModel.fetchTwillioAccessToken(params: params) { dataResponse, error, success, message  in
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
            
            if dataResponse != nil {
                
                if let isSuccess = success {
                    
                    if isSuccess {
                        
                        if let token = dataResponse?.result?.access_token {
                            
                            TwilioChatClient.chatClient(withToken: token, properties: nil,
                                                        delegate: self) { (result, chatClient) in
                                self.client = chatClient
                                
                            }
                        }
                    }
                    else
                    {
                        Utility.showAlertController(self, "Faild!, \(message)")
                    }
                    
                }
                else
                {
                    Utility.showAlertController(self, "Faild!, \(message)")
                }
            }
        }
    }
    
    func shutdown() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }
    
    private func refreshAccessToken() {
        
        let phoneNo = Data?.phone ?? ""
        let params = ["identity" : phoneNo] as [String : AnyObject]
        MessagesDataModel.fetchTwillioAccessToken(params: params) { dataResponse, error, success, message  in
            
            guard let response = dataResponse else {
               print("Error retrieving token: \(error.debugDescription)")
               return
           }
            if let isSuccess = success {
                
                if isSuccess {
                    
                    if let token = response.result?.access_token {
                        
                        self.client?.updateToken(token, completion: { (result) in
                            if (result.isSuccessful()) {
                                print("Access token refreshed")
                            } else {
                                print("Unable to refresh access token")
                            }
                        })
                    }
                }
                else
                {
                    Utility.showAlertController(self, "Faild!, \(message)")
                }
                
            }
            
            if error != nil
            {
                Utility.showAlertController(self, error!.localizedDescription)
            }
        }
    }
    
    func sendMessage(_ messageText: String,
                     completion: @escaping (TCHResult, TCHMessage?) -> Void) {
        if let messages = self.channel?.messages {
            let messageOptions = TCHMessageOptions().withBody(messageText)
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                completion(result, message)
            })
        }
    }
    
    private func scrollToBottomMessage() {
        if messages.count == 0 {
            return
        }
        let bottomMessageIndex = IndexPath(row: messages.count - 1,
                                           section: 0)
        tableViewMessages.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
    
}

extension ChatMessagesViewController : TwilioChatClientDelegate
{
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus)
    {
        guard status == .completed else {
            return
        }
        
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        
        messages.append(message)

        DispatchQueue.main.async {
            if self.messages.count > 0 {
                self.tableViewMessages.reloadData()
                self.scrollToBottomMessage()
            }
            
        }
        
    }
    
    func chatClientTokenWillExpire(_ client: TwilioChatClient) {
        
        refreshAccessToken()
    }
}
