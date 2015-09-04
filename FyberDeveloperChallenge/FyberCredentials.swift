//
//  FyberCredentials.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 04/09/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import Foundation

class FyberCredentials {
    let appID : String
    let userID: String
    let apiKey: String
    
    init (appID: String, userID: String, apiKey: String) {
        self.appID = appID
        self.userID = userID
        self.apiKey = apiKey
    }
}