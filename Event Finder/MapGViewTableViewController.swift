//
//  MapGViewTableViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 19/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import GooglePlacePicker
import GoogleMaps


var  addedBarArray: [NSDictionary] = []

class MapGViewTableViewController: UITableViewController {
    let locationManager = CLLocationManager()
    var placeSelected =  ["id" : "" , "name" : "", "address" : "","latitude" : 0 ,"longitude": 0] as [String : Any]
    
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    // @IBOutlet var nameLabel: UILabel!
    //   @IBOutlet var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadBar"), object: nil)
    }
    @objc func loadList(){
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return addedBarArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)
        
        let currentBar = addedBarArray[indexPath.row]
        cell.textLabel?.text = currentBar.value(forKey: "name") as! String
        cell.detailTextLabel?.text = currentBar.value(forKey: "address") as! String
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.clear
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    
    @IBAction func pickBarPace(_ sender: UIBarButtonItem) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: { (place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                DispatchQueue.main.async {
                    
                    if(place.types.contains("bar")
                        || place.types.contains("restaurant")
                        || place.types.contains("night_club")){
                        var barAddress :String?
                        for component in place.addressComponents! {
                            barAddress = (barAddress ?? "") + " " +  component.name
                        }
                        self.placeSelected["id"] =  place.placeID
                        self.placeSelected["name"] = place.name
                        self.placeSelected["address"] = barAddress
                        self.placeSelected["latitude"] = place.coordinate.latitude
                        self.placeSelected["longitude"] = place.coordinate.longitude
                        
                        if(!addedBarArray.contains(self.placeSelected as NSDictionary))
                        {
                            addedBarArray.append(self.placeSelected as NSDictionary)
                        }
                        //dismiss(animated: true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadBar"), object: nil)
                    }else{
                        let alert = UIAlertController(title: "Info", message: "Not A Bar", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            } else {
                print("No place selected")
                return
            }
            
            //print("Place name \(place?.name)")
            //print("Place address \(String(describing: place?.formattedAddress))")
            //print("Place attributions \(place?.attributions)")
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetails" {
            
            guard let destVC = segue.destination as? PlaceDetailsViewController else { fatalError("bad type, expected PlaceDetailsViewController") }
            
            guard let cell = sender as? UITableViewCell else { return }
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            
            let currentPlaceToSend = addedBarArray[indexPath.row]
            destVC.currentPlace = currentPlaceToSend
        }
    }
}


