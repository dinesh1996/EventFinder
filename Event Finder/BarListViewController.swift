//
//  BarListViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 09/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit

class BarListViewController: UITableViewController {
    
    let dir = BarList(demoData: true)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dir.list().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "restoCell", for: indexPath)
        
        // Configure the cell...
        
        let currentBar = dir.list()[indexPath.row]
        cell.textLabel?.text = currentBar.name
        cell.detailTextLabel?.text = currentBar.address
        
        //Les cells sont recyclées, il faut y penser
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
}

