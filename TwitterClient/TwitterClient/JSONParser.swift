//
//  JSONParser.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/20/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import Foundation

typealias JSONParserCallback = (Bool, [Tweet]?)->()
typealias userParser = (Bool,[String: Any]?) ->()
typealias JSONParserCallbackUsers = (Bool, User?)->()
class JSONParser {
    static var sampleJSONData : Data {
        guard let tweetJSONPath = Bundle.main.url(forResource: "tweet", withExtension: "json") else {
            fatalError("Tweet.json does not exist in this bundle")
        }
        do {
            let tweetJSONData = try Data(contentsOf: tweetJSONPath)
            return tweetJSONData
        } catch {
            fatalError("Failed to create data from tweetJSONPath")
        }
    }
    
    class func tweetsFrom(data: Data, callback: JSONParserCallback){
        do {
            if let rootObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]]{

                var tweets = [Tweet]()
                for tweetDictionary in rootObject {
                    if let tweet = Tweet(json: tweetDictionary){
                        tweets.append(tweet)
                    }
                }
                callback(true, tweets)
            }
        } catch {
            print("Error Serializing JSON")
            callback(false, nil)
        }
    }
    
    class func userFrom(data: Data) -> User? {
        do {
            if let userData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]  {
                let user = User(json: userData)
                return user
            }
        } catch {
            print("Error Bringing the user's info")
            return nil
        }
        return nil
    }
}
