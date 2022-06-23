//
//  MapVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/21.
//

import Foundation
import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var myMap: MKMapView!
        
    @IBOutlet weak var location: UIButton!
    
    @IBAction func showLocation(_ sender: UIButton) {
        let location = myMap.userLocation
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 300, longitudinalMeters: 300)
        myMap.setRegion(region, animated: true)
    }
 
    override func viewDidLoad() {
      
        myMap.showsUserLocation = true
        
    }

}
