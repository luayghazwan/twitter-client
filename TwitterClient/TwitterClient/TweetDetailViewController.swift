//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/22/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    var tweet : Tweet! //Force unwrap is okay here. We dont want it to present if it deosnt have a tweet

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.tweet.user?.name ?? "Unknown") //?? is the nil coalescing. default to nil
        print(self.tweet.text)
        
    }

}
