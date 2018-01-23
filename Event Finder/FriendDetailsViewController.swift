//
//  FriendDetailsViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 13/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit

var  addedFriendsArray: [NSDictionary] = []

class FriendDetailsViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIButton!
    var friendDetail:NSDictionary?
    
    @IBOutlet weak var friendImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let f = friendDetail else { fatalError("No friend provided")}
        configure(with: (f as AnyObject) as! NSDictionary)
        // Do any additional setup after loading the view.
    }
    private func configure(with friend: NSDictionary) {
        
        title = friend.value(forKey: "name")! as? String
        let url = URL(string:(friend.value(forKeyPath: "picture.data.url")! as? String)!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        let img = UIImage(data: data!)!
        self.friendImg.image = img
        
        
    }
    @IBAction func addFriend(_ sender: Any) {
        guard let f = friendDetail else { fatalError("No friend provided")}
        if(!addedFriendsArray.contains(f))
        {
            addedFriendsArray.append(f)
        }
        //dismiss(animated: true
        addButton.isEnabled = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        
    }
}


