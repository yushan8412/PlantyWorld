//
//  FlowerStoreManager.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/6.
//

import Foundation
import FirebaseFirestore

class StoreManager {
    static let shared = StoreManager()
    
    let dataBase = Firestore.firestore()
    
    var storeList = [Store]()
    
    func fetchAllPlants(completion: @escaping ([Store]?) -> Void) {
        dataBase.collection("flowerStore").getDocuments { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else {
                return }
            self.storeList.removeAll()
            for store in querySnapshot.documents {
                let storeObject = store.data(with: ServerTimestampBehavior.none)
                let name = storeObject["name"] as? String ?? ""
                let address = storeObject["address"] as? String ?? ""
                let image = storeObject["image"] as? String ?? ""
                let point = storeObject["point"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0)
              

                let store = Store(address: address, name: name, image: image, point: point)
                self.storeList.append(store)
            }
            print("get store data")
            print(self.storeList)
            completion(self.storeList)
//            print(store)
        }
    }
    
}
