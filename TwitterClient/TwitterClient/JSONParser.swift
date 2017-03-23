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
typealias userParser = (Bool,[String: Any]?) ->()
typealias JSONParserCallbackUsers = (Bool, User?)->()


class JSONParser {
    
    static var sampleJSONData : Data {
        guard let tweetJSONPath = Bundle.main.url(forResource: "tweet", withExtension: "json") else { //Bundle always represent a project, it's part of the foundation, main is a singleton of Bundle
            fatalError("Tweet.json does not exist in this bundle")
        }
        do {
            let tweetJSONData = try Data(contentsOf: tweetJSONPath) //casting contents from json path into tweetJSONData
            return tweetJSONData
        } catch {
            fatalError("Failed to create data from tweetJSONPath")
        }
    }
    
    class func tweetsFrom(data: Data, callback: JSONParserCallback){
        do { //for error handling - 'try'
            if let rootObject = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]]{
                //just setting rootObject to be an array of dictionaries, if it fails the try, we go to catch
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
    
    class func userFrom(data: Data, callback: JSONParserCallbackUsers) -> User? {
        do {
            if let userData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]  {
                let user = User(json: userData)
                callback(true, user)
            }
        } catch {
            print("Error Bringing the user's info")
            return nil
        }
        return nil
    }
}
