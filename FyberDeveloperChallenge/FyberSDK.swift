//
//  FyberSDK.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 14/08/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import Foundation
import AdSupport
import CryptoSwift
import SwiftyJSON

class FyberSDK {
    
    let baseURL = "http://api.sponsorpay.com/feed/v1/offers.json?"
    let appID : String
    let userID: String
    let apiKey: String
    
    // MARK: init
    
    init (appID: String, userID: String, apiKey: String) {
        self.appID = appID
        self.userID = userID
        self.apiKey = apiKey
    }
    
    // MARK: public interface
    
    // requests offers with the parameters specified in the developer challenge
    func requestOffers(completion:[FyberOffer] -> Void) {
        let list = [("offer_types", "112"),
            ("ip", "109.235.143.113")]
        requestOffersWithParameters(list, completion: completion)
    }
    
    // MARK: private functions
    // these methods should actually be private but are public in this example project for testing the class. with the help of the @testable keyword in Swift 2.0 and Xcode 7 testing private methods will not be as problematic anymore
    
    // requests offers with parameters and checks for validity
    func requestOffersWithParameters(list:[(String, String)], completion:[FyberOffer] -> Void) {
        let request = requestStringWithParameters(list)
        
        if (request != nil) {
            if let requestURL = NSURL(string:request!)
            {
                NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: requestURL), queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response, data, error) -> Void in
                    if error == nil {
                        // retrieve signature from response
                        if let signature = (response as? NSHTTPURLResponse)?.allHeaderFields["X-Sponsorpay-Response-Signature"] as? String
                        {
                            // calculate hash response and compare
                            let str = NSString(data:data, encoding:NSUTF8StringEncoding) as! String
                            if let sha1 = (str + self.apiKey).sha1()?.lowercaseString {
                                if (sha1 == signature)
                                {
                                    let offers = JSON(data: data)["offers"]
                                    if offers.type == Type.Array {
                                        completion(offers.arrayValue.map({ FyberOffer(title: $0["title"].string!, teaser: $0["teaser"].string!, thumbnail: $0["thumbnail"]["hires"].string!, payout: $0["payout"].int!) }))
                                    }
                                } else {
                                    println("Error: sigantures do not match")
                                }
                            } else {
                                println("Error: could not calculate hash")
                            }
                        } else {
                            println("Error: no signature found")
                        }
                    } else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
            } else {
                println("Error: unknown URL error")
            }
        } else {
            println("Error: could not compose request string from parameters")
        }
    }
    
    // returns the request string with parameters
    func requestStringWithParameters(list: [(String, String)]) -> String? {
        return requestString(list + mandatoryParameters())
    }
    
    // returns the mandatory parameters string
    func mandatoryParameters() -> [(String, String)] {
        let date = NSDate()
        return [("format", "json"),
            ("appid", appID),
            ("uid", userID),
            ("locale", "DE"),
            ("os_version", UIDevice.currentDevice().systemVersion),
            ("timestamp", String(Int64(date.timeIntervalSince1970))),
            ("apple_idfa_tracking_enabled", ASIdentifierManager.sharedManager().advertisingTrackingEnabled ? "true" : "false"),
            ("apple_idfa", ASIdentifierManager.sharedManager().advertisingTrackingEnabled ? ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString : "")]
    }
    
    // returns the request string
    func requestString(list: [(String, String)]) -> String? {
        // sort the tuples, concatenate them with "=" and the results with "&", drop first character ("&")
        let requestString = dropFirst(list.sorted({ $0.0 < $1.0 }).map({ $0.0 + "=" + $0.1 }).reduce("", combine:{ $0 + "&" + $1 }))
        
        // calculate hash from request and apiKey and compose final request string
        if let sha1 = (requestString + "&" + apiKey).sha1()?.lowercaseString {
            return baseURL + requestString + "&hashkey=" + sha1
        } else {
            return nil
        }
    }
}

// MARK: - container class for offer data

class FyberOffer {
    let title : String
    let teaser : String
    let thumbnail : String
    let payout : Int
    
    init(title : String, teaser : String, thumbnail : String, payout : Int) {
        self.title = title
        self.teaser = teaser
        self.thumbnail = thumbnail
        self.payout = payout
    }
}