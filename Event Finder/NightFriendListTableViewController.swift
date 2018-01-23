//
//  NightFriendListTableViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 16/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit

class NightFriendListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func loadList(){
        
        self.tableView.reloadData()
    }
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addedFriendsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NightFriendCell", for: indexPath)
        
        let currentFriend = addedFriendsArray[indexPath.row]
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
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailsFriend" {
            
            guard let destVC = segue.destination as? NightFriendDetailsViewController else { fatalError("bad type, expected NightFriendDetailsViewController") }
            
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let currentFriend = addedFriendsArray[indexPath.row]
            destVC.friendDetail = currentFriend
        }
    }
    
}

