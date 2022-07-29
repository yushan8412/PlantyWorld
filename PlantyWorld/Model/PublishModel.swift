//
//  PublishModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/15.
//

import Foundation

struct PublishModel: Comparable, Codable {
    static func == (lhs: PublishModel, rhs: PublishModel) -> Bool {
        return lhs.time < rhs.time
    }
    
    static func < (lhs: PublishModel, rhs: PublishModel) -> Bool {
        return lhs.time < rhs.time
    }
    
    var author: Author
    var title: String
    var commands: Command
    var plantID: String
    var time: String
    var userID: String
    
}

struct Command: Codable {
    var command: String
    var commandID: String
}

struct Author: Codable {
    var name: String?
    var id: String
}
