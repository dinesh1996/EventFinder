//
//  BarList.swift
//  Bar Finder
//
//  Created by Dinesh Salhotra on 09/01/2018.
//  Copyright © 2018 Exanity. All rights reserved.
//

import Foundation

struct BarList {
    private var bars: [Bar]
    
    
    init(demoData: Bool = false) {
        bars = []
        if demoData {
            for i in 0...20 {
                let b = Bar(name: "BlaBla\(i)", address: "Adress\(i)", geopoint: GeopointB.init(latitude: 21, longitude: 15), visitor: 2, style: ["\(i)+2 blabla"])
                
                bars.append(b)
            }
        }
    }
    
    func list() -> [Bar] {
        
        for b in bars {
            print(b.name)
        }
        return bars
    }
}

