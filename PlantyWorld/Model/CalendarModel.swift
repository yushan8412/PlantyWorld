//
//  CalendarModel.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/23.
//

import Foundation
import Firebase

struct CalendarModel: Comparable, Codable {

    static func == (lhs: CalendarModel, rhs: CalendarModel) -> Bool {
        return lhs.eventDate < rhs.eventDate
    }
    
    static func < (lhs: CalendarModel, rhs: CalendarModel) -> Bool {
        return lhs.eventDate < rhs.eventDate
    }
    
    var eventDate: String
    var content: String
    var plantID: String
    var dateString: String
    var eventID: String
}
