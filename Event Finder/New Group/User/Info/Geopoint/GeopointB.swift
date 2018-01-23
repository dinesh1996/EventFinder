//
//  GeopointB.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 05/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import Foundation
import CoreLocation

struct GeopointB: Codable {
    init(latitude: Double, longitude: Double ) {
        self.latitude = latitude
        self.longitude = longitude
        
    } 
    var latitude: Double
    var longitude: Double
}

