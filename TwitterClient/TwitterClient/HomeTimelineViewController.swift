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
    
    override func viewDidLoad() {
        super.viewDidLoad() //super represent the parent class, viewDidLoad() fire's off the original (parent) view
        
        self.tableView.dataSource = self //an instance of HomeTimelineViewController, assigns self to be the dataSource for tableView
        self.tableView.delegate = self //response to user's actions
        
        updateTimeline()
        
        //the callback function from JSONParser file (line 31)
        //JSONParser is a class and it has tweetsFrom method. It takes in two parameters () and the trailing closure { }
        JSONParser.tweetsFrom(data: JSONParser.sampleJSONData) { (success, tweets) in //this is the
            if(success){
                guard let tweets = tweets else { fatalError("Tweets came back nil") } //guard let is just like 'if let' but with if, we can have to conditions and work on a longer functionality.
                for tweet in tweets {
                    dataSource.append(tweet)
                    print(tweet.text)
                }
            }
        }
    }
    
    func updateTimeline(){
        API.shared.getTweet { (tweets) in
            OperationQueue.main.addOperation { // Creating an operation queue manually, we dont need to do it this way.
                self.dataSource = tweets ?? [] //repopulate my table view and reload all its data
            }
        }
    }

    //we dont need to call the functions, apple will call them
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //de-queue is to pop something off, remove it and show it on screen when scrolled
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataSource[indexPath.row].text
        cell.detailTextLabel?.text = dataSource[indexPath.row].user?.name //'?' is optional chaining, if the user 'nil' it will fail
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

}

//This is the reversed Array but not sure how to run it
//func reverseArray() -> [Tweet]{
//    let reversedArray : [Tweet] = dataSource.reversed()
//    return reversedArray
//}
