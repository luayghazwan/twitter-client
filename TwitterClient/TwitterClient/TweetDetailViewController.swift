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
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var viewFeedButton: UIButton!
    @IBAction func viewFeedButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "FeedController", sender: sender)
    }
    
    var tweet : Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.tweet.user?.name ?? "Unknown")
        
        self.singleTweetText.text = tweet.text
        self.retweetStatus.text = tweet.isRetweeted ? "Retweeted" : "Not retweeted"
        
        print("THIS IS IT!\(tweet.user!.screenName)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == FeedController.identifier {
            guard let destinationController = segue.destination as? FeedController else { return }
        
            if self.tweet.user != nil {
                destinationController.screenName = tweet.user!.screenName
            } else {
                return
            }
        }
    }
}
