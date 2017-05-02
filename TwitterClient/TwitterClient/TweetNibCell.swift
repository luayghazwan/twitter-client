//
//  TweetNibCell.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/25/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class TweetNibCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            self.usernameLabel.text = tweet.user?.name ?? "Unknown User"
            self.tweetLabel.text = tweet.text
            
            if let user = tweet.user {
                UIImage.fetchImageWith(user.profileImageURL) { (image) in
                    self.userImageView.image = image
                }
            }
        }
    }
}
