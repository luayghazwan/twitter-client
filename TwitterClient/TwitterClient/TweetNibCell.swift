//
//  TweetNibCell.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/25/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class TweetNibCell: UITableViewCell {
    //we will programmatically design the UI for the cell instead of StoryBoard
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var tweetLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
