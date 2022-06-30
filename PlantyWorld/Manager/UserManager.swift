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
    
    func addUser(name: String, uid: String, email: String, image: String) {
        //        func addUser(name: String, uid: String, email: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        //        guard let currentUser = Auth.auth().currentUser else { return }
        
        //        let userID = currentUser.uid
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
        //
        //        checkUser(userID: userID) { isExists in
        //            if !isExists {
        //                do {
        //
        //                    try  document.setData(data)
        //
        //                    completion(true)
        //                    print("user data update")
        //
        //                } catch {
        //
        //                    completion(false)
        //                    print("Fail to create user.")
        //                }
        //            }
        //        }
        
        //
        document.setData(data) { error in
            if let error = error {
                print("Error\(error)")
            } else {
                print("User Document update!!")
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
            //            self.userData
            for data in querySnapshot.documents {
                let userdata = data.data(with: ServerTimestampBehavior.none)
                let userName = userdata["name"] as? String ?? ""
                let userEmail = userdata["email"] as? String ?? ""
                let userID = userdata["id"] as? String ?? ""
                let userImage = userdata["image"] as? String ?? ""
                
                let user = User(userID: userID, name: userName, userImage: userImage, useremail: userEmail)
                self.userData = user
            }
            completion(.success(self.userData ?? User(userID: "", name: "", userImage: "", useremail: "")))
            
            print("0000\(self.userData)")
        }
    }
    
    func updateUserInfo(uid: String, image: String, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let docRef = dataBase.collection("user").document(uid).updateData([
            "name": name,
            "image": image
        ])
        completion(.success(()))
    }
    
    func deleteUser() {
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
            // Account deleted.
          }
        }
    }
}
