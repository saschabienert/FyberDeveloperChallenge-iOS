//
//  FormViewController.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 16/08/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet var appIDTextField: UITextField!
    @IBOutlet var userIDTextField: UITextField!
    @IBOutlet var apiKeyTextField: UITextField!
    @IBOutlet var showOffersButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let appID = userDefaults.objectForKey("appID") as? String {
            appIDTextField.text = appID
        }
        if let userID = userDefaults.objectForKey("userID") as? String {
            userIDTextField.text = userID
        }
        if let apiKey = userDefaults.objectForKey("apiKey") as? String {
            apiKeyTextField.text = apiKey
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showOffers() {
        if let appID = appIDTextField.text, userID = userIDTextField.text, apiKey = apiKeyTextField.text {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setObject(appID, forKey: "appID")
            userDefaults.setObject(userID, forKey: "userID")
            userDefaults.setObject(apiKey, forKey: "apiKey")
            
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as? ViewController
            {
                vc.formViewController = self
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
