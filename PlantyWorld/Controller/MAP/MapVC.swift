//
//  MapVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/21.
//

import Foundation
import UIKit
import MapKit
import Kingfisher
import FirebaseFirestore

class MapVC: UIViewController {
    
    @IBOutlet weak var myMap: MKMapView!
        
    @IBOutlet weak var location: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func showLocation(_ sender: UIButton) {
        let location = myMap.userLocation
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 1000, longitudinalMeters: 1000)
        myMap.setRegion(region, animated: true)
    }
    let layout = UICollectionViewFlowLayout()
    
    var selectedIndex = 0
    
    private var isSearchResults = false
    
    var storeList: [Store] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = UIColor(patternImage: UIImage(named: "32e3a86d9a8999f0632a696f3500c675")!)
        
        let nibcell = UINib(nibName: "MapDetailCell", bundle: nil)
        collectionView.register(nibcell, forCellWithReuseIdentifier: "MapDetailCell")

        collectionView.dataSource = self
        collectionView.delegate = self
      
        myMap.showsUserLocation = true
        setupUI()
        setCollectionView()
        location.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        print(storeList)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStoreData()
        dropPin()
    }
    
    func getStoreData() {
        StoreManager.shared.fetchAllPlants { stores in
            self.storeList = stores ?? []
            print("00000\(self.storeList)")
            self.collectionView.reloadData()
            self.dropPin()
        }
    }
    
    func dropPin() {
        for pin in storeList {
            let mark = MKPointAnnotation()
            mark.coordinate = CLLocationCoordinate2D(latitude: pin.point.latitude, longitude: pin.point.longitude)
            mark.title = pin.name
            myMap.addAnnotation(mark)
        }
        
    }
    
    func setCollectionView() {
        view.addSubview(collectionView)
        view.addSubview(location)
//        collectionView.isHidden = true

        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                              right: view.rightAnchor, paddingLeft: 0, paddingBottom: 80,
                              paddingRight: 0, height: 220)
    }

    func setupUI() {
        location.tintColor = .black
        location.backgroundColor = .pgreen
        location.layer.cornerRadius = 10
        location.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        location.setTitle("Me", for: .normal)
    }
    
    private func setRegionToAnnotation() {
        var store: Store?
        if isSearchResults {
            store = storeList[selectedIndex]
        } else {
            store = storeList[selectedIndex]
        }
        if let store = store {
            let selectedLocation = CLLocationCoordinate2D(latitude: store.point.latitude,
                                                          longitude: store.point.longitude)
            myMap.setRegion(MKCoordinateRegion(center: selectedLocation,
                                               latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
        }
    }

}

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MapDetailCell", for: indexPath) as? MapDetailCell
        else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear

        cell.storeImage.kf.setImage(with: URL(string: storeList[indexPath.item].image))
        cell.storeName.text = storeList[indexPath.item].name
        cell.storeAddress.text = storeList[indexPath.item].address
        return cell
                
    }
    
}


extension MapVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width - 2 * 16.0, height: size.height - 2 * 6.0)

    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 8
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 16.0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 6.0, left: 16.0, bottom: 6.0, right: 16.0)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let itemSize = CGSize(width: collectionView.frame.size.width - 2 * 16,
                              height: collectionView.frame.size.height - 2 * 6)
        let xCenterOffset = targetContentOffset.pointee.x + (itemSize.width / 2.0)
        let indexPath = IndexPath(item: Int(xCenterOffset / (itemSize.width + 16 / 2.0)), section: 0)
        let offset = CGPoint(x: (itemSize.width + 16.0 / 2.0) * CGFloat(indexPath.item), y: 0)
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        targetContentOffset.pointee = offset
        selectedIndex = indexPath.row
        setRegionToAnnotation()
    }

}

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
//        let pin = myMap.annotations as?
//        let selectedLocation = CLLocationCoordinate2D(latitude: self.store.point.latitude,
//                                                      longitude: self.store.point.longitude)
//        myMap.setRegion(MKCoordinateRegion(center: selectedLocation,
//                                           latitudinalMeters: 800, longitudinalMeters: 800), animated: true)
    }
}
