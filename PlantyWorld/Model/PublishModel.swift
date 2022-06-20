//
//  PublishModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation

struct PublishModel: Comparable {
    static func == (lhs: PublishModel, rhs: PublishModel) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func < (lhs: PublishModel, rhs: PublishModel) -> Bool {
        return lhs.time < rhs.time
    }
    
    var author: Author
    var title: String
    var content: String
    var time: Date
    var id: String
    
}

struct Author: Codable {
    var email: String
    var name: String
    var id: String
}
