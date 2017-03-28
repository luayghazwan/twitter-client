//
//  FeedController.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/27/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTable: UITableView!
    
    var screenName : String!
    
    var tweetsArray = [Tweet]() {
        didSet{
            self.feedTable.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedTable.dataSource = self
        self.feedTable.delegate = self
        
        let tweetNib = UINib(nibName: "TweetNibCell", bundle: nil)
        self.feedTable.register(tweetNib, forCellReuseIdentifier: TweetNibCell.identifier)
        
        self.feedTable.estimatedRowHeight = 50
        self.feedTable.rowHeight = UITableViewAutomaticDimension
        
        
        updateFeedView()
        
    }
    
    func updateFeedView(){
        API.shared.getTweetsFor(screenName, callback: { (tweets) in
            if (tweets != nil){
                OperationQueue.main.addOperation {
                    self.tweetsArray = tweets!
                }
            }
         })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetNibCell.identifier, for: indexPath) as? TweetNibCell
        
        let tweet = self.tweetsArray[indexPath.row]
        
        cell?.tweet = tweet
        
        return cell!
    }

}
