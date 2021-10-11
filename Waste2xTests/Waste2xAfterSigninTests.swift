//
//  Waste2xAfterSigninTests.swift
//  Waste2xTests
//
//  Created by Phaedra Solutions  on 09/10/2021.
//  Copyright © 2021 codesrbit. All rights reserved.
//

import XCTest
@testable import Waste2x

class Waste2xAfterSigninTests: XCTestCase {

    override func setUpWithError() throws {
        DataManager.shared.setUser(user: "b3d46d6cca80f885f784168397d3bbd49dbc318c") // Need to send model instead of token
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

}
