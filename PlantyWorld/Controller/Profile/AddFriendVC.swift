//
//  AddFriendVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Firebase


class AddFriendVC: UIViewController {
    
    var titleLB = UILabel()
    var searchBtn = UIButton()
    var searchTXF = UITextField()
    var tableView = UITableView()
    var friendData: User?
    
    override func viewDidLoad() {
        view.backgroundColor = .lightOrange
        self.tabBarController?.tabBar.isHidden = true
        view.addSubview(titleLB)
        view.addSubview(searchBtn)
        view.addSubview(searchTXF)
        view.addSubview(tableView)
        setup()
    }
    
    func setup() {
        
        titleLB.anchor(bottom: searchTXF.topAnchor, paddingBottom: 16)
        titleLB.centerX(inView: view)
        titleLB.text = " Enter Your Frends Email "
        titleLB.textColor = .darkGray
        
        searchTXF.center(inView: view, yConstant: -100)
        searchTXF.anchor(width: 300, height: 40)
        searchTXF.backgroundColor = .white
        searchTXF.textColor = .black
        searchTXF.placeholder = " Friend's Email "
        
        searchBtn.anchor(top: searchTXF.bottomAnchor, paddingTop: 16)
        searchBtn.centerX(inView: view)
        searchBtn.setTitle(" Search ", for: .normal)
        searchBtn.backgroundColor = .dPeach
        
        searchBtn.addTarget(self, action: #selector(searchFriend), for: .touchUpInside)

    }
    
    @objc func searchFriend() {
        self.checkEmail(email: searchTXF.text ?? "")
        self.searchTXF.text = ""
        
    }
    
    func checkEmail(email: String) {
        let db = Firestore.firestore()
        
        //在"user_data"collection裡，when the "email" in firebase is equal to chechEmail的參數email, than get that document.
        db.collection("user").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            
            if let querySnapshot = querySnapshot {
                if let document = querySnapshot.documents.first {
                    self.confirm()
                    
                    for data in querySnapshot.documents {
                        let userdata = data.data(with: ServerTimestampBehavior.none)
                        let userName = userdata["name"] as? String ?? ""
                        let userEmail = userdata["email"] as? String ?? ""
                        let userID = userdata["id"] as? String ?? ""
                        let userImage = userdata["image"] as? String ?? ""
                        
                        let user = User(userID: userID, name: userName, userImage: userImage, useremail: userEmail)
                        self.friendData = user

                    }
                    print(document.data())
                    print("your friend is exist")
                    print(self.friendData)
                    print(email)
                        
                } else {
                    
                    print("nobody here")
                    print(email)
                }
            }
        }
    }

    
    func confirm() {
        // 建立一個提示框
        let db = Firestore.firestore()

        let alertController = UIAlertController(
            title: "送出好友邀請",
            message: "確認要送出了嗎？",
            preferredStyle: .alert)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: "送出",
            style: .default,
            handler: { _ in
                db.collection("user").document(Auth.auth().currentUser?.uid ?? "").updateData([
                    "followList": FieldValue.arrayUnion([ "\(self.friendData?.userID ?? "")"])
                    //document.update -> don't have this member in document, so need to connect it with .reference
                ])
            })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }

    

    
//    @objc func goNextVC() {
//
//        let loginVC = LoginVC()
//
//        navigationController?.pushViewController(loginVC, animated: true)
//    }
}
