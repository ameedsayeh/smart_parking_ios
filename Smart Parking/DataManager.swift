//
//  DataManager.swift
//  Smart Parking
//
//  Created by Ameed Sayeh on 7/28/20.
//  Copyright © 2020 Ameed Sayeh. All rights reserved.
//

import Foundation
import Firebase
import CodableFirebase

class DataManager {
    
    var ref: DatabaseReference?
    
    static private var sharedInstance: DataManager?
    
    static func shared() -> DataManager {
        
        if sharedInstance == nil {
            sharedInstance = DataManager()
        }
        
        return sharedInstance!
    }
    
    private init() {
        self.ref = Database.database().reference()
    }
    
    func getParkings(completion: @escaping (Parking) -> Void) {
        
        guard let dRef = self.ref else { return }
        
        let parkingRef = dRef.child("Parkings")
        
        parkingRef.observe(.childAdded, with: { (snapshot) in
            guard let value = snapshot.value else { return }
            do {
                let item = try FirebaseDecoder().decode(Parking.self, from: value)
                completion(item)
            } catch let error {
                print(error)
            }
            
        })
    
        parkingRef.observe(.childChanged, with: { (snapshot) in
            
            guard let value = snapshot.value else { return }
            do {
                let item = try FirebaseDecoder().decode(Parking.self, from: value)
                completion(item)
            } catch let error {
                print(error)
            }
            
        })
    }
}
