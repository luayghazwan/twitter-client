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
    
    var user : User? //Most tweets have user, but some of them might be not
    
    // if the json fails to grab data from "text or "id_str", nil will be returned with No Valid Tweet, but if we get to the if statement and the "user" is not defined then, it will return a valid tweet but with nil value.
    init?(json: [String: Any]){ //Because we used Any we should use as? String next line
        if let text = json["text"] as? String,
            let id = json["id_str"] as? String {
            self.text = text
            self.id = id
            if let userDictionary = json["user"] as? [String:Any]{ //"user" is handling our tweet
                self.user = User(json: userDictionary)
            }
        } else {
            return nil
        }
    }
}
