//
//  AccountViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 15/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseDatabase

class AccountViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBAction func logoutButton(_ sender: UIButton) {
        print("logout")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            performSegue(withIdentifier: "logout", sender:self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = currentUser {
            lastNameLabel.text  = ((currentUser as AnyObject).value(forKeyPath: "last_name") as? String)
            firstNameLabel.text  = ((currentUser as AnyObject).value(forKeyPath: "first_name") as? String)
            emailLabel.text  = ((currentUser as AnyObject).value(forKeyPath: "email") as? String)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

