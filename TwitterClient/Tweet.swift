//
//  Tweet.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/20/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import Foundation

class Tweet {
    let text : String
    let id : String
    var isRetweeted = false
    
    var user : User?
    init?(json: [String: Any]){
        if let text = json["text"] as? String,
            let id = json["id_str"] as? String {
            self.text = text
            self.id = id
            if let _ = json["retweeted_status"] as? [String: Any] {
                isRetweeted = true
            }
            if let userDictionary = json["user"] as? [String:Any]{
                self.user = User(json: userDictionary)
            }
        } else {
            return nil
        }
    }
}
