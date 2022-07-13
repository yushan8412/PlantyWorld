//
//  FlowerStoreManager.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/6.
//

import Foundation
import FirebaseFirestore

struct Store {
    let address: String
    var name: String
    var image: String
    var point: GeoPoint
}
