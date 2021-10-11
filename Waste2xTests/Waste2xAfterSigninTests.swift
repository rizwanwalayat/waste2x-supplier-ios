//
//  Waste2xAfterSigninTests.swift
//  Waste2xTests
//
//  Created by Phaedra Solutions  on 09/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import XCTest
@testable import Waste2x
@testable import TwilioChatClient

class Waste2xAfterSigninTests: XCTestCase {

    override func setUpWithError() throws {
        
        DataManager.shared.setUser(user: "{\"success\":false,\"result\":{\"percentage\":1.776,\"waste_types\":[],\"email\":\"asad.mukhtarrrrr@phaedrasolutions.com\",\"code\":\"\",\"waste_id\":1,\"is_new_user\":false,\"phone\":\"+10000060\",\"auth_token\":\"3c5dde6a8a5eced578960b6fe35641df13f42d98\",\"farm_exist\":true,\"farmer_medals\":0,\"stripe_account_name\":\"None\",\"stars_earned\":8},\"message\":\"\",\"status_code\":[\"\"]}")
        // alteast the token value following auth_token needs to be updated, otherwise the complete result model converted into JSONString can updated here
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testHomeScreenAPI() throws {
        let promise = expectation(description: "Status Code: 200")

        HomeFetchFarmsDataModel.fetchSites { result, error, status, message in
            
            XCTAssert(status ==  true && error == nil, "Data Returned with Error")
            
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let _ = error {
                XCTFail("Timeout")
            }
        }
    }

    func testNotificationAPI() throws {
        
        let promise = self.expectation(description: "Status Code: 200")
        
        NotificationModel.notificationApiFunction { result, error, status, message in
            
            XCTAssert(status == true && error == nil , "Data Returned with Error, \(message)")
            XCTAssertNotNil(result?.result, "Expected non-nil result")
            promise.fulfill()
        }
        
        waitForExpectations(timeout: 10) { error in
            if let _ = error {
                XCTFail("Timeout")
            }
        }
    }

    
    func testNewsAPI() throws {
        
        let promise = self.expectation(description: "News Status Code: 200")
        
        NewsModel.NewsApiCall { result, error, status,message in
            
            XCTAssert(status == true && error == nil, "Data returned with error, \(message)")
            XCTAssertNotNil(result?.result, "Expected non-nil result")
            promise.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { error in
            if let _ = error {
                XCTFail("Timeout")
            }
        }
    }
    
    func testFAQsAPI() throws {
        
        let promise = expectation(description: "Status Code: 200")
        
        FaqModel.FaqApiFunction { result, error, status,message in
            
            XCTAssert(status == true && error == nil, "Data returned with error, \(message)")
            
            guard let result = result?.result else
            {
                XCTFail("Expected non-nil result")
                return
            }
            
            promise.fulfill()
            
            self.waitForExpectations(timeout: 10) { error in
                if let _ = error {
                    XCTFail("Timeout")
                }
            }
        }
    }
    
    func testPaymentAPI() throws {
        
        let promise = expectation(description: "Status Code: 200")
        
        PaymentModel.paymentApiFunction { result, error, status,message in
            
            XCTAssert(status == true && error == nil, "Data returned with error, \(message)")
            
            guard let result = result?.result else
            {
                XCTFail("Expected non-nil result")
                return
            }
            
            promise.fulfill()
            
            self.waitForExpectations(timeout: 10) { error in
                if let _ = error {
                    XCTFail("Timeout")
                }
            }
        }
    }
    
    func testPaymentAPI() throws {
        
        let promise = expectation(description: "Status Code: 200")
        
        PaymentModel.paymentApiFunction { result, error, status,message in
            
            XCTAssert(status == true && error == nil, "Data returned with error, \(message)")
            
            guard let result = result?.result else
            {
                XCTFail("Expected non-nil result")
                return
            }
            
            promise.fulfill()
            
            self.waitForExpectations(timeout: 10) { error in
                if let _ = error {
                    XCTFail("Timeout")
                }
            }
        }
    }
    
    func testMessagestAPIToFetchAccessToken() throws {
        
        let promise = expectation(description: "Status Code: 200")
        
        MessagesDataModel.fetchTwillioAccessToken { result, error, status,message in
            
            XCTAssert(status == true && error == nil, "Data returned with error, \(message)")
            
            guard let resultData = result?.result, let accessToken = resultData.access_token else
            {
                XCTFail("Expected non-nil result")
                return
            }
            
            TwilioChatClient.chatClient(withToken: accessToken, properties: nil,
                                        delegate: nil) { (result, chatClient) in
                
                XCTAssert(result.isSuccessful() && chatClient != nil, "Data returned with error, \(message)")
            }
            
            promise.fulfill()
            
            self.waitForExpectations(timeout: 10) { error in
                if let _ = error {
                    XCTFail("Timeout")
                }
            }
        }
    }
}
