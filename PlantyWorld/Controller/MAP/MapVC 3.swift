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
                                        latitudinalMeters: 1000, longitudinalMeters: 1000)
        myMap.setRegion(region, animated: true)
    }
 
    override func viewDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = UIColor(patternImage: UIImage(named: "32e3a86d9a8999f0632a696f3500c675")!)
      
        myMap.showsUserLocation = true
        showFlowerStore()
        setupUI()
        location.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)

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
        
        let pin3 = MKPointAnnotation()
        pin3.coordinate = CLLocation(latitude: 25.084987, longitude: 121.557791).coordinate
        pin3.title = "內湖花市"
        myMap.addAnnotation(pin3)
        
        let pin4 = MKPointAnnotation()
        pin4.coordinate = CLLocation(latitude: 25.115664, longitude: 121.503884).coordinate
        pin4.title = "大台北聯合花市"
        myMap.addAnnotation(pin4)
        
        let pin5 = MKPointAnnotation()
        pin5.coordinate = CLLocation(latitude: 25.094949, longitude: 121.498110).coordinate
        pin5.title = "台北花卉村"
        myMap.addAnnotation(pin5)
        
        let pin6 = MKPointAnnotation()
        pin6.coordinate = CLLocation(latitude: 25.104086, longitude: 121.511688).coordinate
        pin6.title = "大台北花園"
        myMap.addAnnotation(pin6)

    }
    
    func setupUI() {
        location.tintColor = .black
        location.backgroundColor = .pgreen
        location.layer.cornerRadius = 10
        location.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
    }

}
