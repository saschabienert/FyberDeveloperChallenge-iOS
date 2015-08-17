//
//  SDKStaticTests.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 17/08/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import UIKit
import XCTest

class SDKStaticTests: XCTestCase {
    
    var sdk = FyberSDK(appID: "",userID: "",apiKey: "")
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sdk = FyberSDK(appID: "test", userID: "test", apiKey: "e95a21621a1865bcbae3bee89c4d4f84")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStaticRequestStringEmpty() {
        XCTAssert(sdk.requestString([
            ("", "")]) == "http://api.sponsorpay.com/feed/v1/offers.json?=&hashkey=3c9d9121b897fa93ec4449bf75a72f6669ce62f1", "Pass")
    }
    
    func testStaticRequestStringExample() {
        XCTAssert(sdk.requestString([
            ("appid", "157"),
            ("uid", "player1"),
            ("ip", "212.45.111.17"),
            ("locale", "de"),
            ("device_id", "2b6f0cc904d137be2e1730235f5664094b831186"),
            ("ps_time", "1312211903"),
            ("pub0", "campaign2"),
            ("page", "2"),
            ("timestamp", "1312471066")]) == "http://api.sponsorpay.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b831186&ip=212.45.111.17&locale=de&page=2&ps_time=1312211903&pub0=campaign2&timestamp=1312471066&uid=player1&hashkey=58eeddf43cfbf81bc307d44d7f9a805a31d94228", "Pass")
    }
    
    func testStaticMandatoryParameters() {
        let mandatoryParameters = ["format", "appid", "uid", "locale", "os_version", "timestamp", "apple_idfa_tracking_enabled", "apple_idfa"]
        let parameters = sdk.mandatoryParameters()
        let containsEightParameters = count(parameters) == 8
        let containsNonEmptyStrings = parameters.map({(count($0.0) > 0) && (count($0.1) > 0)}).reduce(true, combine: { $0 && $1 })
        let containsMandatoryParameters = parameters.map({contains(mandatoryParameters, $0.0)}).reduce(true, combine: { $0 && $1 })
        XCTAssert(containsEightParameters && containsNonEmptyStrings && containsMandatoryParameters, "Pass")
    }
    
    func testStaticRequestOffers() {
        let expectation = expectationWithDescription("request offers from backend")
        
        sdk = FyberSDK(appID: "2070", userID: "spiderman", apiKey: "1c915e3b5d42d05136185030892fbb846c278927")
        sdk.requestOffers() {
            offers in
            if (offers.count > 0)
            {
                expectation.fulfill()
                XCTAssert(true, "Pass")
            }
            else
            {
                XCTAssert(false, "Pass")
            }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testStaticRequestOffersWithParameters() {
        let expectation = expectationWithDescription("request offers from backend")
        
        sdk = FyberSDK(appID: "2070", userID: "spiderman", apiKey: "1c915e3b5d42d05136185030892fbb846c278927")
        sdk.requestOffersWithParameters([("offer_types", "112"),
            ("ip", "109.235.143.113")]) {
                offers in
                if (offers.count > 0)
                {
                    expectation.fulfill()
                    XCTAssert(true, "Pass")
                }
                else
                {
                    XCTAssert(false, "Pass")
                }
        }
        
        waitForExpectationsWithTimeout(5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
