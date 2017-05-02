//
//  UIExtensions.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/25/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

extension UIImage {
    typealias ImageCallback = (UIImage?)->()
    
    class func fetchImageWith(_ urlString: String, callback: @escaping ImageCallback){
        OperationQueue().addOperation {
            guard let url = URL(string: urlString) else {callback(nil);return}
            
            if let data = try? Data(contentsOf: url){
                guard let image = UIImage(data: data) else {  callback(nil); return }
                
                OperationQueue.main.addOperation {
                    callback(image)
                }
            } else {
            OperationQueue.main.addOperation {
                callback(nil)
                }
            }
        }
    }
}

extension UIResponder {
    static var identifier : String {
        return String(describing: self)
    }
}
