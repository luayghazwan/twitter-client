    //
//  HomeTimelineViewController.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/20/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dataSource = [Tweet]()
        {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Timeline"
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let tweetNib = UINib(nibName: "TweetNibCell", bundle: nil)
        
        self.tableView.register(tweetNib, forCellReuseIdentifier: TweetNibCell.identifier)
        
        updateTimeline()
        
        JSONParser.tweetsFrom(data: JSONParser.sampleJSONData) { (success, tweets) in
            if(success){
                guard let tweets = tweets else { fatalError("Tweets came back nil") }
                for tweet in tweets {
                    dataSource.append(tweet)
                    print(tweet.text)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier! {
        case TweetDetailViewController.identifier:
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                let selectedTweet = self.dataSource[selectedIndex]
                
                guard let destinationController = segue.destination as? TweetDetailViewController else { return }
                destinationController.tweet = selectedTweet
                
            }
        case UserAccountViewController.identifier:
            guard segue.destination is UserAccountViewController else { return }
        default:
            return
        }
    }
    
    func updateTimeline(){
        self.activityIndicator.startAnimating()
        API.shared.getTweet { (tweets) in
            OperationQueue.main.addOperation {
                self.dataSource = tweets ?? []
                self.activityIndicator.stopAnimating()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TweetNibCell.identifier, for: indexPath) as! TweetNibCell
        let tweet = self.dataSource[indexPath.row]
        cell.tweet = tweet
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: TweetDetailViewController.identifier, sender: nil)
    }
}
