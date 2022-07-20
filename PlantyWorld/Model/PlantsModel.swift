//
//  PlantsModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct PlantsModel: Comparable {
    static func < (lhs: PlantsModel, rhs: PlantsModel) -> Bool {
        return lhs.date < rhs.date
    }
    static func == (lhs: PlantsModel, rhs: PlantsModel) -> Bool {
        return lhs.date < rhs.date
    }
    
    var userName: String = ""
    var userImage: String = ""
    var name: String = ""
    var date: String = ""
    var sun: Int = 0
    var water: Int = 0
    var note: String = ""
    var image: String = ""
    var id: String = ""
    var createdTime: Timestamp = Timestamp()
}
