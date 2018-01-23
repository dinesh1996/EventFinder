//
//  HomePageViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 21/11/2017.
//  Copyright © 2017 Exanity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseDatabase

var friends:NSArray = NSArray()
var currentUser:Any?
var nightsArray: [AnyObject] = []


class HomePageViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var descriptionText: UILabel!
    var ref: DatabaseReference!
    let loginButton = FBSDKLoginButton()
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout")
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.center = view.center
        self.loginButton.readPermissions = ["public_profile", "email","user_friends"]
        self.loginButton.delegate = self
        view.addSubview(loginButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current()) == nil{
            super.viewDidAppear(animated)
        } else {
            Auth.auth().signIn(with: FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)) { (user, error) in
                if let error = error {
                    print(error)
                }else {
                    self.returnUserData()
                    self.friendsList()
                    self.getNights(completion: { (result) in
                        nightsArray = result
                        self.performSegue(withIdentifier: "loginSuccess", sender: self)
                    })
                }
                
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
        if let facebookToken = FBSDKAccessToken.current(){
            let credential =  FacebookAuthProvider.credential(withAccessToken:facebookToken.tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print(error)
                }else {
                    print("success")
                    self.getNights(completion: { (result) in
                        nightsArray = result
                    })
                }
            }
        }
        else {
            print("User Said No to the consent")
            descriptionText.text = "You have to accept the consent to use the app"
        }
    }
    
    private  func returnUserData(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath:"me",parameters: ["fields": "id,email,gender,link,locale,name,timezone,updated_time,verified,last_name,first_name,middle_name"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
            }
            else
            {
                print("fetched user: \(String(describing: result))")
                if let userName : String = (result as AnyObject).value(forKeyPath: "name") as? String{
                    print("User Name is: \(userName)")
                    currentUser = result
                }else {
                    print("Error : With the name")
                }
            }
        })
    }
    
    private func friendsList() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields":"birthday,first_name,last_name,email,picture"])
        graphRequest.start( completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("Error: \(String(describing: error))")
                return
            }
            let summary =  (result as AnyObject).value(forKeyPath:"summary") as! NSDictionary
            let counts = summary.value(forKeyPath:"total_count") as! NSNumber
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "id,name,picture.type(large)", "limit": "\(counts)"])
            graphRequest.start( completionHandler: { (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    print("Error: \(String(describing: error))")
                    return
                }
                else
                {
                    friends = (result as AnyObject).value(forKeyPath:"data") as! NSArray
                    var count = 1
                    if let array = friends as? [NSDictionary] {
                        for friend : NSDictionary in array {
                            let name = friend.value(forKey: "name") as! NSString
                            print("\(count) \(name)")
                            count+=1
                        }
                    }
                }
            })
        })
    }
    
    private func getNights(completion:  @escaping (_ nightsList: [AnyObject]) -> Void){
        self.ref = Database.database().reference()
        var nightsListRaw: [AnyObject] = []
        self.ref.child("nights").observe(DataEventType.value) { (snapshot) in
            if  (snapshot.value as? [String : AnyObject]  != nil){
                let nights = snapshot.value as! [String : AnyObject]
                if  let username:String = ((currentUser as AnyObject).value(forKeyPath: "name") as? String){
                    for night in nights{
                        var isHisNight = false
                        if let friendList:[String : AnyObject] =  night.value.value(forKeyPath: "friends") as? [String : AnyObject] {
                            if(night.value.value(forKeyPath: "info.admin")! as! String  == (currentUser as AnyObject).value(forKeyPath: "name")! as! String  ) {
                                nightsListRaw.append(night.value)
                            }
                            for friend in friendList{
                                print(friend)
                                print(friend.value.value(forKey: "name")!)
                                if let friendName:String = friend.value.value(forKey: "name") as? String {
                                    if (username  == friendName){
                                        isHisNight = true
                                        break
                                    }
                                }
                            }
                            if(isHisNight){
                                nightsListRaw.append(night.value)
                            }
                            
                        }
                    }
                }
                
            }
            completion(nightsListRaw)
            
        }
    }
}

