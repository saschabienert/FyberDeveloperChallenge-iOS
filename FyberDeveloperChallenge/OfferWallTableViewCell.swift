//
//  OfferWallTableViewCell.swift
//  FyberDeveloperChallenge
//
//  Created by Sascha Bienert on 15/08/15.
//  Copyright (c) 2015 Sascha Bienert. All rights reserved.
//

import UIKit

class OfferWallTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var teaserLabel: UILabel!
    @IBOutlet var payoutLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
