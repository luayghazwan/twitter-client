//
//  API.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/21/17.
//  Copyright © 2017 Luay Younus. All rights reserved.


// HTTP REQUEST
//-------------
//200 OK
//2xx worked
//4xx client's fault (aka our app) - wrong url, bad auth, asking for resource that's not there
//5xx Server Error - server issue, not client's.

// Social framework 'SLRequest' to http request from Twitter or other API …. Account has nothing to do with that
// perform() is used once the reqest is done

import Foundation
import Accounts
import Social

typealias AccountCallback = (ACAccount?)->() //using an Alias name for the stuff after "="
typealias UserCallback = (User?)->()
typealias TweetsCallback = ([Tweet]?)->()

class API{
    static let shared = API()
    
    var account: ACAccount? //because what if the user didn't want to login
    
    
    //by default, closures are marked as escaping - the callback will escape out of the func to get data back... usually used with Asynchrnous calls
    private func login(callback: @escaping AccountCallback){ //it should be private for safety of login
        
        //creating an instance
        let accountStore = ACAccountStore()
        
        //'accountType' instance method because it's called on an instance
        let accountType = accountStore.accountType(withAccountTypeIdentifier:ACAccountTypeIdentifierTwitter) //(typing ACAcc will show us autocomplete for twitter) 
        
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (success, error) in
            
            if let error = error{ //if it's not nil, enter the if statement. error should be non-optional
                print("Errorrr!: \(error.localizedDescription)")
                callback(nil)
                return
            }
            
            if success {
                //first is to just get the first account from the users array coming from 'accounts' instance method
                if let  account = accountStore.accounts(with: accountType).first as? ACAccount {
                    callback(account)
                }
                
            } else {
                print("The user did not allow access to their account")
                callback(nil)
            }
        }
        
    }
    private func getOAuth(callback: @escaping UserCallback){
        let url = URL(string: "https://api.twitter.com/1.1/account/verify_credentials.json") //base url for twitter's API
        
        //Imports Social up (line 11) to access social and use 'SLRequest'
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil){
            request.account = self.account
            request.perform(handler: {(data,response,error) in
            
                if let error = error {
                    print ("Error: \(error)")
                    callback(nil) //works with marking the function @escaping
                    return
                }
                
                guard let response = response else {callback(nil); return} // the ';' will treat it as two indiviual lines of code
                guard let data = data else {callback(nil); return}
                
                switch response.statusCode {
                case 200...299:     //building the successful state .. parsing the data from JSONParser file.swift
                    let user = JSONParser.userJSON(data: data)
                    callback(user)
                case 400...499:
                    print("Error: response came back with statusCode: \(response.statusCode)")
                    callback(nil)
                case 500...599:
                    print("Error: Client Side Error. The response came back with statusCode: \(response.statusCode)")
                    callback(nil)
                default:
                    print("Error: Server Side Error. The response came back with statusCode: \(response.statusCode)")
                    callback(nil)
                }
            })
            //callbacks, perform, completion are the same concepts but different names
        }
        
    }
    private func updateTimeLine(callback: @escaping TweetsCallback){
        let url = URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        
        if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: url, parameters: nil){
            request.account = self.account
            request.perform(handler: { (data, response, error) in
                if let error = error {
                    print("Error: Error requesting user's home timeline - \(error.localizedDescription)")
                    callback(nil)
                    return
                }
                guard let response = response else {
                    callback(nil)
                    return
                }
                guard let data = data else {callback(nil);return}
                
                if response.statusCode >= 200 && response.statusCode < 300 {
                    JSONParser.tweetsFrom(data: data, callback: { (success, tweets) in //callback: is not the callback function.it's a parameter name of the varialbe or argument from 'tweetsFrom'
                        
                        if success{
                            callback(tweets)
                        }
                    })
                    
                } else {
                    print("Something else went terribly wront! We have a status code outside 200-299.")
                    callback(nil)
                }
            })

        }
    }
    func getTweet (callback: @escaping TweetsCallback){
        if self.account == nil { // it means we didn't sing in/log in with user account
            login(callback: { (account) in // now we have to unwrap it as always
                if let account = account {
                    self.account = account
                    self.updateTimeLine(callback: { (tweets) in //line 140 is a shorter - more verbose way to do it
                        callback(tweets)
                    })
                }
            })
        } else {
            self.updateTimeLine(callback: callback)
        }
    }
}
