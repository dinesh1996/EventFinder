//
//  NightListTableViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 16/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NightListTableViewController: UITableViewController {
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "nightLoad"), object: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    private  func getData() {
        self.ref = Database.database().reference()
        self.ref.child("nights").observe(DataEventType.value) { (snapshot) in
            nightsArray.removeAll()
            if  snapshot != nil{
                let  nights = snapshot.value as! [String : AnyObject]
                
                for night in nights{
                    nightsArray.append(night.value)
                }
            }
        }
    }
    
    @objc func loadList(){
        getData()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nightsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nightCell", for: indexPath)
        
        let currentNight = nightsArray[indexPath.row]
        
        if let labelText =  (currentNight as AnyObject).value(forKeyPath:"info.name") as? String{
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
        
        if segue.identifier == "NightshowDetails" {
            
            guard let destVC = segue.destination as? NightDetailsViewController else { fatalError("bad type, expected NightDetailsViewController") }
            
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let currentNight = nightsArray[indexPath.row]
            destVC.nightDetail = currentNight as AnyObject
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

