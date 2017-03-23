//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/22/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var singleTweetText: UILabel!
    
    @IBOutlet weak var retweetStatus: UILabel!
    
    
    var tweet : Tweet! //Force unwrap is okay here. We dont want it to present if it deosnt have a tweet

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.tweet.user?.name ?? "Unknown") //?? is the nil coalescing. default to nil
        
        self.singleTweetText.text = tweet.text
        
        if (!tweet.retweetStatus) {
            self.retweetStatus.text = "Not Retweeted"
        } else {
            self.retweetStatus.text = "This is a retweeted Tweet"
        }
    }
}
