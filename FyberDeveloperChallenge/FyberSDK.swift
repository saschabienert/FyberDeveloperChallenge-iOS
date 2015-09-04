//
//  FyberSDK.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 04/09/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import UIKit

// MARK: public interface

class FyberSDK {
    let credentials: FyberCredentials
    var delegate: OfferDelegate?
    
    // MARK: init
    
    init (appID: String, userID: String, apiKey: String) {
        self.credentials = FyberCredentials(appID: appID, userID: userID, apiKey: apiKey)
    }

    // MARK: load

    func loadOfferWithHostViewController(host:UIViewController)
    {
        var storyBoard:UIStoryboard? = nil
        storyBoard = UIStoryboard(name:"OfferWall", bundle: nil)
        if let offerWallViewController = storyBoard?.instantiateViewControllerWithIdentifier("OfferWallViewController") as? OfferWallViewController
        {
            offerWallViewController.credentials = credentials
            offerWallViewController.hostViewController = host
            offerWallViewController.delegate = delegate
            host.presentViewController(offerWallViewController, animated: true, completion: nil)
        }
    }
}

// MARK: OfferDelegate protocol

@objc protocol OfferDelegate {
    
    // offers have been loaded successfully
    optional func offersDidLoad()
    
    // there has been an error with loading offers (this is too generic, should be improved)
    optional func offersFailedLoad()
    
    // the user closed the offer wall
    optional func userClosedOffers()
    
    // the user has chosen an offer
    optional func userChosedOffer(offer: Int)
    
    // an offer has been displayed to the user (appeared on screen in the offer wall)
    optional func offerDidAppear(offer: Int)
}