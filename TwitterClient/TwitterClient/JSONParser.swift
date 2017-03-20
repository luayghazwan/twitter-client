//
//  JSONParser.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/20/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import Foundation

//notes:
//[[String : Any]] is a main array with objects/arrays inside from the JSON file

//typealias - we can give a name to another type renaming a name (ex: typealias AdamInt Int)
typealias JSONParserCallback = (Bool, [Tweet]?)->()

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
            //jsonObject is type method
            //root object is the object thats parsed from JSON //option: MutableContaienrs usually work perfectly!
        } catch {
            print("Error Serializing JSON")
            callback(false, nil)
        }
    }
}
