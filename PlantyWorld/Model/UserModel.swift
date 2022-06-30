//
//  UserModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/27.
//

import Foundation

struct User: Codable, Equatable {
    let userID: String
    var name: String
    var userImage: String
//    var userImageID: String
    var useremail: String
//    var blockedUserID: [String]
}
