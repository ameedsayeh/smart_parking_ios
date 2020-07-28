//
//  ParkingViewModel.swift
//  Smart Parking
//
//  Created by Ameed Sayeh on 7/28/20.
//  Copyright © 2020 Ameed Sayeh. All rights reserved.
//

import Foundation

struct ParkingViewModel {
    
    var title: String
    var subtitle: String
    var freeLots: Int = 0
    var distance: String?
    
    init(parking: Parking) {
        self.title = parking.title
        self.subtitle = parking.subtitle
        self.freeLots = parking.freeLots()
        if let _distance = parking.distance {
            self.distance = "\((_distance / 1000.0).rounded(toPlaces: 2))"
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
