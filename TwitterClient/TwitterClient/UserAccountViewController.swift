//
//  UserAccountViewController.swift
//  TwitterClient
//
//  Created by Luay Younus on 3/22/17.
//  Copyright © 2017 Luay Younus. All rights reserved.
//

import UIKit

class UserAccountViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImg: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    
    
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userFrom()
    }
    
    func userFrom() {
        API.shared.getOAuth { (users) in
            guard let theUser = users else {fatalError("Error grabing the user")}
            OperationQueue.main.addOperation {
                self.user = theUser
                self.name.text = "Name \(self.user.name)"
                self.profileImg.text = "Pic \(self.user.profileImageURL)"
                self.userLocation.text = "Location \(self.user.location)"
            }
        }
    }
}
