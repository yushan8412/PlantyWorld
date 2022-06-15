//
//  PlantsModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation

struct PlantsModel: Comparable {
    static func < (lhs: PlantsModel, rhs: PlantsModel) -> Bool {
        return lhs.dateOfPurchase < rhs.dateOfPurchase
    }
    static func == (lhs: PlantsModel, rhs: PlantsModel) -> Bool {
        return lhs.dateOfPurchase < rhs.dateOfPurchase
    }
    
    var name: String
    var dateOfPurchase: Date
    var sun: Int
    var water: Int
    var note: String
}
