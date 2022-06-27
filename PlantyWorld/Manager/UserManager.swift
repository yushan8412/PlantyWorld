//
//  UserManager.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/27.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Firebase


class UserManager {
    
    static let shared = UserManager()
    
    var currentUser: User?
        
    private let dataBase = Firestore.firestore()
    
    
    
    func addUser(name: String, email: String) {
        let user = dataBase.collection("user")
        let document = user.document()
        let timeInterval = Date()
        let userID = document.documentID
        let data: [String: Any] = [
            "email": email,
            "name": Auth.auth().currentUser?.displayName ?? "no User Name",
            "id": userID,
            "name": name,
            "createdTime": timeInterval
        ]
        
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("Document update!!")
            }
        }
    }

    
    
 
}
