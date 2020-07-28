//
//  Parking.swift
//  Smart Parking
//
//  Created by Ameed Sayeh on 7/28/20.
//  Copyright © 2020 Ameed Sayeh. All rights reserved.
//

import Foundation

struct Parking: Decodable {
    
    var id: String
    var title: String
    var subtitle: String
    var location: Location
    var lots: [Bool]
    var distance: Double?
    
    func freeLots() -> Int {
        
        var count = 0
        for lot in lots {
            if !lot {
                count += 1
            }
        }
        return count
    }
}


struct Location: Decodable {
    
    var latitude: Double
    var longitude: Double
}
