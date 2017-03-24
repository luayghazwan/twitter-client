    //
//  HomeTimelineViewController.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/20/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //UIViewController is the home protocol.
    
    var dataSource = [Tweet]()
        { // creating an observer, anytime new tweets get assigned new data, our table will reload new data

        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        //super represent the parent class, 'HomeTimelineViewController' is conforming to UIViewController (super class) , viewDidLoad() fire's off the original (parent) view
        super.viewDidLoad()
        
        self.navigationItem.title = "My Timeline"
        
        self.tableView.estimatedRowHeight = 50 //UI - related to the view of the table
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.dataSource = self //an instance of HomeTimelineViewController, assigns self to be the dataSource for tableView
        self.tableView.delegate = self //response to user's actions
        
        updateTimeline()
        
        
        //the callback function from JSONParser file (line 31)
        //JSONParser is a class and it has tweetsFrom method. It takes in two parameters () and the trailing closure { }
        JSONParser.tweetsFrom(data: JSONParser.sampleJSONData) { (success, tweets) in
            if(success){
                guard let tweets = tweets else { fatalError("Tweets came back nil") } //guard let is just like 'if let' but with if, we can have to conditions and work on a longer functionality.
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
        case "TweetDetailViewController":
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                let selectedTweet = self.dataSource[selectedIndex]
                
                guard let destinationController = segue.destination as? TweetDetailViewController else { return }
                
                destinationController.tweet = selectedTweet
                
            }
        case "UserAccountViewController":
            guard segue.destination is UserAccountViewController else { return }
        default:
            return
        }
        
//        if segue.identifier == "showDetailSegue" {
//            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row { //index value represents the tweet clicked on
//                let selectedTweet = self.dataSource[selectedIndex]
//                
//                guard let destinationController = segue.destination as? TweetDetailViewController else {return}
//                
//                destinationController.tweet = selectedTweet //destinationController is the subclass that we add the tweet to
//
//            }
//        }
    }
    
        
    func updateTimeline(){
        self.activityIndicator.startAnimating() //showing the Activity inicator loading icon
        API.shared.getTweet { (tweets) in
            OperationQueue.main.addOperation { // Creating an operation queue manually, we dont need to do it this way.
                self.dataSource = tweets ?? [] //repopulate my table view and reload all its data
                self.activityIndicator.stopAnimating()
            }
        }
    }

    //we dont need to call the functions, apple will call them
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //de-queue is to pop something off, remove it and show it on screen when scrolled
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath)
        
        //taking cell again, if we can cast it and assign it again to cell. It's not considered Mutating.
        if let cell = cell as? TweetCell {
            cell.cellTitle.text = dataSource[indexPath.row].text
            cell.cellSubtitle.text = dataSource[indexPath.row].user?.name
        }
        return cell
    }
    
    
    //just a function the prints the index clicked on
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        print(indexPath.row)
    //    }

}

//This is the reversed Array but not sure how to run it
//func reverseArray() -> [Tweet]{
//    let reversedArray : [Tweet] = dataSource.reversed()
//    return reversedArray
//}
