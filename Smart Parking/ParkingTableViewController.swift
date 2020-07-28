//
//  ParkingTableViewController.swift
//  Smart Parking
//
//  Created by Ameed Sayeh on 7/28/20.
//  Copyright © 2020 Ameed Sayeh. All rights reserved.
//

import UIKit
import MapKit

class ParkingTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let cellReuseIdentifier = "parkingCell"
    var userLocation: Location = Location(latitude: 23, longitude: 23)

    var parkings: [Parking] = [
    ]
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Smart Parking"
        
        self.tableView.register(UINib(nibName: "ParkingTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        self.getParkings()
        self.sortParkings()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLocation.latitude = locValue.latitude
        self.userLocation.longitude = locValue.longitude
        self.sortParkings()
        self.tableView.reloadData()
    }
    
    func getParkings() {
        
        DataManager.shared().getParkings { (parking) in
            
            var found = false
            
            for i in 0..<self.parkings.count {
                if self.parkings[i].id == parking.id {
                    self.parkings[i] = parking
                    found = true
                    break
                }
            }
            
            if !found {
                self.parkings.append(parking)
            }
            
            self.sortParkings()
            self.tableView.reloadData()
        }
        //DataManager.shared
    }
    
    func sortParkings() {
        
        for i in 0..<parkings.count {
            let userLocation = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
            let location = CLLocation(latitude: parkings[i].location.latitude, longitude: parkings[i].location.longitude)
            parkings[i].distance = userLocation.distance(from: location)
        }
        
        self.parkings.sort { (p1, p2) -> Bool in
            return p1.distance! < p2.distance!
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.parkings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ParkingTableViewCell
        cell.setup(viewModel: ParkingViewModel(parking: self.parkings[indexPath.row]))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openMapForPlace(lat: self.parkings[indexPath.row].location.latitude, long: self.parkings[indexPath.row].location.longitude, placeName: self.parkings[indexPath.row].title)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    public func openMapForPlace(lat:Double = 0, long:Double = 0, placeName:String = "") {
        let latitude: CLLocationDegrees = lat
        let longitude: CLLocationDegrees = long

        let regionDistance:CLLocationDistance = 100
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
    }

}
