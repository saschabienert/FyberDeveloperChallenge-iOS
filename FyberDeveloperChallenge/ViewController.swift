//
//  ViewController.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 14/08/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var formViewController: FormViewController?
    @IBOutlet var tableView: UITableView!
    @IBOutlet var noDataLabel: UILabel!
    var refreshControl:UIRefreshControl!
    
    var offers : [FyberOffer]? = []
    var imageCache = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to reload")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = max(UITableViewAutomaticDimension, 70)
        self.tableView.estimatedRowHeight = 70
        self.tableView.addSubview(refreshControl)
        
        refresh(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        imageCache = [String:UIImage]()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func enterCredentials() {
        formViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refresh(sender:AnyObject)
    {
        offers = []
        imageCache = [String:UIImage]()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let appID = userDefaults.objectForKey("appID") as? String, userID = userDefaults.objectForKey("userID") as? String, apiKey = userDefaults.objectForKey("apiKey") as? String {
            FyberSDK(appID: appID, userID: userID, apiKey: apiKey).requestOffers() {
                [weak self] offers in
                self?.offers = offers
                self?.tableView.reloadData()
                
                UIView.animateWithDuration(0.5, animations: {
                    [weak self] in
                    self?.tableView.alpha = 1;
                    self?.noDataLabel.alpha = 0;
                    })
                
                self?.refreshControl.endRefreshing()
            }
        } else {
            
        }
        
        UIView.animateWithDuration(0.5, animations: {
            [weak self] in
            self?.tableView.alpha = 0;
            self?.noDataLabel.alpha = 1;
            })
    }
    
    // MARK: table view stuff
    
    private let cellReuseIdentifier: String = "FyberTableViewCell"
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers != nil ? offers!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // dequeue or create cell
        var cell: FyberTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as? FyberTableViewCell
        if (cell == nil) {
            cell = FyberTableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:cellReuseIdentifier)
        }
        
        if ((offers != nil) && offers!.count >= indexPath.row) {
            // set properties
            let offer = offers![indexPath.row]
            cell?.titleLabel.text = offer.title
            cell?.payoutLabel.text = String(offer.payout)
            cell?.teaserLabel.text = offer.teaser
            
            // check if thumbnail is cached
            if let img = imageCache[offer.thumbnail.sha1()!] {
                cell?.thumbnailImageView.image = img
            } else {
                cell?.thumbnailImageView.image = UIImage()
                // the thumbnail is not cached. download the image data on a background thread
                if let imageURL = NSURL(string: offer.thumbnail)
                {
                    NSURLConnection.sendAsynchronousRequest(NSURLRequest(URL: imageURL), queue: NSOperationQueue.mainQueue(), completionHandler: {
                        (response, data, error) -> Void in
                        if error == nil {
                            // convert data to image. if it is a valid image store it into the cache and update the cell (on main thread)
                            if let image = UIImage(data: data) {
                                self.imageCache[offer.thumbnail.sha1()!] = image
                                dispatch_async(dispatch_get_main_queue(), {
                                    [weak self] in
                                    self?.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                                    })
                            }
                        } else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                }
            }
        }
        
        return cell!
    }
}

