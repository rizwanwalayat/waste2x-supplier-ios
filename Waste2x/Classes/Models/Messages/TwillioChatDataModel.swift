//
//  TwillioChatDataModel.swift
//  EnMass
//
//  Created by MAC on 21/06/2021.
//  Copyright © 2021 Haider Awan. All rights reserved.
//

import Foundation
import TwilioChatClient

protocol TwillioChatDataModelDelegate: AnyObject {
    func reloadAllMessages()
    func receivedNewMessage()
    func tokeExpired()
    func failedToConnect()
    func connectCompleted()
}

class TwillioChatDataModel: NSObject {
    
    static let shared = TwillioChatDataModel()
    
    // MARK: Chat variables
    var client: TwilioChatClient?
    var channel: TCHChannel?
    var messages: [TCHMessage] = []
    var delegate : TwillioChatDataModelDelegate?
    var messagesPage = 1
    var messagesPageCount = 50
    var identity: String?
    
    func loginToTwillio(with token : String, identity: String)
    {
        TwilioChatClient.chatClient(withToken: token, properties: nil,
                                    delegate: self) { (result, chatClient) in
            self.client = chatClient
            self.identity = identity
        }
    }
    
    func sendMessage(_ messageText: String,
                     completion: @escaping (TCHResult?, TCHMessage?) -> Void) {
        if let messages = self.channel?.messages {
            let messageOptions = TCHMessageOptions().withBody(messageText)
            messages.sendMessage(with: messageOptions, completion: { (result, message) in
                completion(result, message)
            })
        }
        else {
            
            completion(nil, nil)
        }
    }
    
    
    private func checkChannelCreation(_ completion: @escaping(TCHResult?, TCHChannel?) -> Void) {
        guard let client = client, let channelsList = client.channelsList() else {
            return
        }
        
        channelsList.channel(withSidOrUniqueName: self.identity ?? "", completion: { (result, channel) in
            completion(result, channel)
        })
    }
    
    private func joinChannel(_ channel: TCHChannel) {
        self.channel = channel
        if channel.status == .joined {
            print("Current user already exists in channel")
            self.delegate?.connectCompleted()
            self.fetchLastMessages()
            
        } else {
            channel.join(completion: { result in
                print("Result of channel join: \(result.resultText ?? "No Result")")
                self.delegate?.connectCompleted()
                self.fetchLastMessages()
            })
        }
    }
    
    private func createChannel(_ completion: @escaping (Bool, TCHChannel?) -> Void) {
        guard let client = client, let channelsList = client.channelsList() else {
            
            return
        }
        
        let options: [String: Any] = [
            TCHChannelOptionUniqueName: self.identity ?? ""
            ]
        channelsList.createChannel(options: options, completion: { channelResult, channel in
            if channelResult.isSuccessful() {
                print("Channel created.")
            } else {
                print("Channel NOT created.")
            }
            completion(channelResult.isSuccessful(), channel)
        })
    }
    
    func shutdown() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
            self.messages.removeAll()

        }
    }
    
    func fetchLastMessages()
    {
        if let messages = self.channel?.messages{
            
            messages.getLastWithCount(UInt(messagesPageCount)) { result, messageHistory in
                
                if result.isSuccessful() {
                    
                    if let lastMessages = messageHistory{
                        
                        self.messages = lastMessages
                        self.delegate?.reloadAllMessages()
                        Utility.hideLoading()
                    }
                }
            }
        } 
    }
    
    func fetchMoreMesseges()
    {
        messagesPage += 1
        messagesPageCount = messagesPageCount * messagesPage
        fetchLastMessages()
    }
}

extension TwillioChatDataModel : TwilioChatClientDelegate
{
    func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus)
    {
        print("status is : \(status)")
        switch status {
        case .started:
            
            print("started")
            
        case .completed:
            
            print("completed")
            guard status == .completed else {
                return
            }
            
            checkChannelCreation { (result , channel) in
                if let channel = channel {
                    self.joinChannel(channel)
                } else {
                    self.createChannel { (success, channel) in
                        if success, let channel = channel {
                            self.joinChannel(channel)
                        }
                    }
                }
            }
            
        case .failed:
            
            print("failed")
            delegate?.failedToConnect()
            
        default:
            
            print(status)
            
        }
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        
        
        messages.append(message)

        DispatchQueue.main.async {
            self.delegate?.reloadAllMessages()
            if self.messages.count > 0 {
                self.delegate?.receivedNewMessage()
            }
        }
    }
    
    func chatClientTokenWillExpire(_ client: TwilioChatClient) {
        
        delegate?.tokeExpired()
    }
    
}
