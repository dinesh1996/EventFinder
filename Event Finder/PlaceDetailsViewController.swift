//
//  PlaceDetailsViewController.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 21/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class PlaceDetailsViewController: UIViewController {
    
    var currentPlace:NSDictionary?
    
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var gMap: GMSMapView!
    let placesClient = GMSPlacesClient.shared()
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let latitude =  currentPlace!["latitude"] as? CLLocationDegrees else { fatalError("bad type, expected latitude") }
        guard let longitude =  currentPlace!["longitude"] as? CLLocationDegrees else { fatalError("bad type, expected longitude") }
        
        let camera = GMSCameraPosition.camera(withLatitude:latitude, longitude:longitude, zoom: 15.0)
        self.gMap.animate(to: camera)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker( position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        marker.title = currentPlace?["name"] as? String
        marker.snippet = currentPlace?["address"] as? String
        marker.appearAnimation = .pop
        marker.map = self.gMap
        labelName.text = currentPlace?["name"] as? String
        labelAddress.text = currentPlace?["address"] as? String
        
    }
}




