//
//  Bar.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 09/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import Foundation
struct Bar: Codable{
    init(name:String, address:String ,geopoint:GeopointB ,visitor:Int , style:[String]) {
        self.name = name
        self.address = address
        self.geopoint = geopoint
        self.visitor = visitor
        self.style = style
    }
    var name:String
    var address:String
    var geopoint:GeopointB
    var visitor:Int
    var style:[String]
    
}


