//
//  NightInfoBarListTableViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 21/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NightInfoBarListTableViewController: UITableViewController {
    var ref: DatabaseReference!
    var nightName: String?
    override func viewDidLoad() {
        loadList()
        super.viewDidLoad()
        
        
    }
    func getData() {
        self.ref = Database.database().reference()
        self.ref.child("nights/"+nightName! + "/bars").observe(DataEventType.value) { (snapshot) in
            let bars = snapshot.value as! [String : AnyObject]
            nightBarsArray.removeAll()
            
            for bar in bars{
                nightBarsArray.append(bar.value)
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
        return nightBarsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nightBarCell", for: indexPath)
        
        let currentNightBar = nightBarsArray[indexPath.row]
        
        if let labelText =  (currentNightBar as AnyObject).value(forKeyPath:"name") as? String{
            cell.textLabel?.text = labelText
        }
        
        // Configure the cell...
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NightBarshowDetails" {
            
            guard let destVC = segue.destination as? PlaceDetailsViewController else { fatalError("bad type, expected PlaceDetailsViewController") }
            
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            
            
            var currentPlace =   ["id" : "" , "name" : "", "address" : "","latitude" : 0 ,"longitude": 0] as [String : Any]
            
            currentPlace["id"] =  nightBarsArray[indexPath.row].value(forKeyPath:"placeID")
            currentPlace["name"] =  nightBarsArray[indexPath.row].value(forKeyPath:"name")
            currentPlace["address"] =  nightBarsArray[indexPath.row].value(forKeyPath:"address")
            currentPlace["latitude"] =  nightBarsArray[indexPath.row].value(forKeyPath:"latitude")
            currentPlace["longitude"] =  nightBarsArray[indexPath.row].value(forKeyPath:"longitude")
            
            
            destVC.currentPlace = currentPlace as NSDictionary
            
            
            
        }
    }
    
    
    
    
}

