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
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var user : User!
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.getOAuth { (user) in
            guard let theUser = user else {fatalError("Error grabing the user")}
            OperationQueue.main.addOperation {
                self.user = theUser
                self.name.text = "\(self.user.name)"
                self.userLocation.text = "\(self.user.location)"
                self.downloadProfileImage()
            }
        }
    }

    func downloadProfileImage() {
        OperationQueue.main.addOperation {
            if let imageURLString = self.user?.profileImageURL {
                let imageURL = URL(string: imageURLString)
                if let profileImage = try? UIImage(data: NSData(contentsOf: imageURL!) as Data) {
                    return self.profileImage.image = profileImage
                }
            }
        }
    }

}

//    func UIImagetoUIimageView() -> URL {
//        let imageView = UIImageView(prof)
//        let image = UIImage(named: downloadProfileImage)
//        imageView.image = image
//        return self.view.addSubview(imageView)

// 1. string -> URL
// 2. get data from url
// 3. conver data to UIImage
// 4. put image to imgaeView.image
