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
        self.navigationController?.navigationBar.backgroundColor = .clear
      
        myMap.showsUserLocation = true
        showFlowerStore()
        setupUI()
    }
    
    func showFlowerStore() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocation(latitude: 25.0635950, longitude: 121.5739108).coordinate
        pin.title = "台北花市"
        pin.subtitle = "台北市內湖區"
        myMap.addAnnotation(pin)
        
        let pin2 = MKPointAnnotation()
        pin2.coordinate = CLLocation(latitude: 25.035186, longitude: 121.537847).coordinate
        pin2.title = "建國花市"
        myMap.addAnnotation(pin2)
        
    }
    
    func setupUI() {
        location.tintColor = .black
        location.backgroundColor = .pgreen
        location.layer.cornerRadius = 10
    }

}
