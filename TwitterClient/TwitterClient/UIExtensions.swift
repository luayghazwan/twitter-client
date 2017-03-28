//
//  UIExtensions.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/25/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit


//code snippet that we drop into our project that makes 
extension UIImage {
    typealias ImageCallback = (UIImage?)->()
    
    class func fetchImageWith(_ urlString: String, callback: @escaping ImageCallback){
        OperationQueue().addOperation {
            // to fetch image we usually get the image as String, we convert it to URL, Then convert the URL to Data, after that render it on UI
            
            
            guard let url = URL(string: urlString) else {callback(nil);return}
            
            if let data = try? Data(contentsOf: url){
                
                guard let image = UIImage(data: data) else {  callback(nil); return }
                
                // we can ommit this else callback with the guard at the beginning since the closure in typealias returns an optional '?' so if the 'image' constant returns nil, it will be handled for us and passed in to the OperationQueue
                
                OperationQueue.main.addOperation {
                    callback(image)
                }
            } else {
            
            OperationQueue.main.addOperation { //handling edge cases in case we didnt get data back
                callback(nil)
                }
            }
        }
    }
}


//anything globally will now have an identifier, it applys for HomeViewController, every view , every class and subclass 
extension UIResponder {
    //static means it lives on the actual type and not the instance
    
    static var identifier : String {
        return String(describing: self)
    }
}
