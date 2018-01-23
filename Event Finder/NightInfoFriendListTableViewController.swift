//
//  NightInfoFriendListTableViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 17/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NightInfoFriendListTableViewController: UITableViewController {
    var ref: DatabaseReference!
    var nightName:String?
    override func viewDidLoad() {
        loadList()
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    private  func getData() {
        self.ref = Database.database().reference()
        self.ref.child("nights/"+nightName! + "/friends").observe(DataEventType.value) { (snapshot) in
            let friends = snapshot.value as! [String : AnyObject]
            nightFriendsArray.removeAll()
            for friend in friends{
                nightFriendsArray.append(friend.value)
            }
            self.tableView.reloadData()
        }
    }
    @objc func loadList(){
        getData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nightFriendsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nightFriendCell", for: indexPath)
        
        let currentFriend = nightFriendsArray[indexPath.row]
        cell.textLabel?.text = (currentFriend as AnyObject).value(forKey: "name")! as? String
        
        let url = URL(string:((currentFriend as AnyObject).value(forKeyPath: "picture.data.url")! as? String)!)
        let imageName = "facebook-avatar.jpg"
        let image = UIImage(named: imageName)
        cell.imageView?.image = image
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!){
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data)
                }
            }
            
        }
        
        // Configure the cell...
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     if segue.identifier == "NightBarshowDetails" {
     
     guard let destVC = segue.destination as? NightDetailsViewController else { fatalError("bad type, expected NightDetailsViewController") }
     
     guard let cell = sender as? UITableViewCell else { return }
     guard let indexPath = tableView.indexPath(for: cell) else { return }
     
     let currentNight = nightsArray[indexPath.row]
     destVC.nightDetail = currentNight as AnyObject
     }
     }
     */
    
    
    
}

