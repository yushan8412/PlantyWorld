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
    
    private init() {}
    
    private let dataBase = Firestore.firestore()
    
    func createUserInfo(name: String, imageURL: String?, imageID: String?, completion: @escaping (_ isSuccess: Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        let userID = currentUser.uid
        let user = User(userID: userID,
                        name: name,
                        userImageURL: imageURL,
                        userImageID: imageID)
        
        let userRef = dataBase.collection("user")
        let document = userRef.document()
        
        searchUserIsExist(userID: userID ) { isExists in
            if !isExists {
                do {
                    
                    try document.setData(user)
                    
                    self.currentUser = user
                    
                    completion(true)
                    
                } catch {
                    
                    completion(false)
                    print("Fail to create user.")
                }
            }
        }
    }
    
    
    
    func searchUserIsExist(userID: String, completion: @escaping (_ isExist: Bool) -> Void) {
        
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
}
