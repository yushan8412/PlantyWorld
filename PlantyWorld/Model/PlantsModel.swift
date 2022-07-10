//
//  PlantsModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation
import FirebaseFirestore

struct PlantsModel: Comparable {
    static func < (lhs: PlantsModel, rhs: PlantsModel) -> Bool {
        return lhs.date < rhs.date
    }
    static func == (lhs: PlantsModel, rhs: PlantsModel) -> Bool {
        return lhs.date < rhs.date
    }
    
//    var author: Author
    var userName: String
    var userImage: String
    var name: String
    var date: String
    var sun: Int
    var water: Int
    var note: String
    var image: String
    var id: String
    var createdTime: Timestamp
}
