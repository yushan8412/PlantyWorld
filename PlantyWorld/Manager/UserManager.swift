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
    
    func addUser(name: String, uid: String, email: String, image: String, completion: @escaping((Error?) -> Void)) {

        let user = dataBase.collection("user")
        let document = user.document(uid)
        let timeInterval = Date()
        let data: [String: Any] = [
            "email": email,
            "auth": currentUser,
            "id": uid,
            "name": name,
            "image": image,
            "followList": [],
            "createdTime": timeInterval
        ]
    
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("User Document update!!")
                completion(nil)
            }
        }
    }
    
    func checkUser(userID: String, completion: @escaping (_ isExist: Bool) -> Void) {
        
        let userRef = dataBase.collection("user")
        
        userRef.document(userID).getDocument { document, _ in
            if let document = document {
                
                if document.exists {
                    
                    completion(true)
                    
                } else {
                    
                    completion(false)
                }
                
            } else {
                
                completion(false)
            }
        }
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<User, Error>) -> Void) {
        dataBase.collection("user").whereField("id", isEqualTo: userID).getDocuments { (querySnapshot, _) in
            guard let querySnapshot = querySnapshot else {
                return }
            for data in querySnapshot.documents {
                let userdata = data.data(with: ServerTimestampBehavior.none)
                let userName = userdata["name"] as? String ?? ""
                let userEmail = userdata["email"] as? String ?? ""
                let userID = userdata["id"] as? String ?? ""
                let userImage = userdata["image"] as? String ?? ""
                let followList = userdata["followList"] as? [String] ?? [""]
                let blockList = userdata["blockList"] as? [String] ?? [""]

                let user = User(userID: userID, name: userName, userImage: userImage,
                                useremail: userEmail, followList: followList, blockList: blockList)
                self.userData = user
            }
            completion(.success(self.userData ?? User(userID: "", name: "", userImage: "",
                                                      useremail: "", followList: [""], blockList: [""])))
            
        }
    }
    
    func updateUserInfo(uid: String, image: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        dataBase.collection("user").document(uid).updateData([
            "name": name,
            "image": image
        ])
        completion(.success(()))
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if error != nil {
            // An error happened.
          } else {
            // Account deleted.
          }
        }
    }
    
    func deleteFriend(ownerID: String, userID: String) {
        let documentRef = dataBase.collection("user").document(ownerID)
        documentRef.updateData([
            "followList": FieldValue.arrayRemove(["\(userID)"])
        ])
            print("deleted doc!!")

    }
}
