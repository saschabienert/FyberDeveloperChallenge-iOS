//
//  SDKRandomTests.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 17/08/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import UIKit
import XCTest

class SDKRandomTests: XCTestCase {
    
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
    
    func testRandomRequestStringExample() {
        var randomReferenceParameters: [(String, String)] = []
        
        // create 50 pairs of random strings (length 30)
        for index in 1...50 {
            randomReferenceParameters.append((randomStringWithLength(30), randomStringWithLength(30)))
        }
        var shuffledParameters = randomReferenceParameters
        
        // get request string for random parameters
        let referenceString = sdk.requestString(randomReferenceParameters)
        
        // iterate through 100 permutations of the random parameters and compare if the resulting request string is the same
        for iteration in 1...100 {
            shuffledParameters.permute()
            if (referenceString != sdk.requestString(shuffledParameters))
            {
                XCTAssert(false, "Pass")
                return
            }
        }
        
        XCTAssert(true, "Pass")
    }
    
    // MARK: - helper
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return String(randomString)
    }
}

extension Array {
    mutating func permute() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swap(&self[i], &self[j])
        }
    }
}

