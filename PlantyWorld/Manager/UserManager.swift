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
    
    var userData: User?
    
    func addUser(name: String, uid: String, email: String) {
//        guard let currentUser = Auth.auth().currentUser else {
//            return
//        }

        let user = dataBase.collection("user")
        let document = user.document()
        let timeInterval = Date()
//        let userID = document.documentID
//        let uid = currentUser.uid
        let data: [String: Any] = [
            "email": email,
            "auth": currentUser,
//            "auth": Auth.auth().currentUser?.displayName ?? "nil",
            "id": uid,
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
    
    func fetchUserData(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        dataBase.collection("user").whereField("id", isEqualTo: userID).getDocuments { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else {
                return }
//            self.userData
            for data in querySnapshot.documents {
                let userdata = data.data(with: ServerTimestampBehavior.none)
                let userName = userdata["name"] as? String ?? ""
                let userEmail = userdata["email"] as? String ?? ""
                let userID = userdata["id"] as? String ?? ""
//                let userImage = userdata["image"] as? String ?? ""
                
                let user = User(userID: userID, name: userName, useremail: userEmail)
                self.userData = user
            }
            completion(.success(self.userData ?? User(userID: "", name: "", useremail: "")))
            
            print("0000\(self.userData)")
        }
    }
}
