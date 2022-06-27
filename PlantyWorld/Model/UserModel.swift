//
//  UserModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/27.
//

import Foundation

struct User: Codable {
    let userID: String
    var name: String?
    var userImageURL: String?
    var userImageID: String?
    var blockedUserID: [String]?
}
