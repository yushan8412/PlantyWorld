//
//  FriendListVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/5.
//

import Foundation
import UIKit
import Kingfisher
import FirebaseAuth
import FirebaseFirestore

class FriendsListVC: UIViewController {
    
    var tableView = UITableView()
    var titleLB = UILabel()
    var userData: User?
    var user: User?
    var friendList: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        view.addSubview(titleLB)
        view.addSubview(tableView)
//        view.backgroundColor = .peach
        view.backgroundColor = UIColor(patternImage: UIImage(named: "286765a6ce7d6835bcf31047ca916f1d")!)
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
        print(userData?.followList.count as Any)
        
        self.tableView.register(UINib(nibName: "FriendListCell", bundle: nil),
                                forCellReuseIdentifier: "FriendListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        getFriendList()
    }
    
    func setupUI() {
        titleLB.anchor(top: view.topAnchor, paddingTop: 100)
        titleLB.centerX(inView: view)
        titleLB.text = "FOLLOWING USER"
        titleLB.font = UIFont(name: "Marker Felt", size: 34)
        titleLB.textColor = .black
        
        tableView.backgroundColor = .clear
        tableView.anchor(top: titleLB.bottomAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    func getFriendList() {
        self.friendList.removeAll()
        for userId in userData?.followList ?? [] {
            UserManager.shared.fetchUserData(userID: userId) { result in
                switch result {
                case .success(let user):
                    self.friendList.append(user)
                case .failure:
                    print("Error")
                }
            }
        }
    }
    
    func confirmUnfollow(userid: String) {
        // 建立一個提示框
        let alertController = UIAlertController(
            title: "Unfollow Friend?",
            message: "Are you sure you want to unfollow this user？",
            preferredStyle: .alert)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: "YES",
            style: .default,
            handler: { _ in
                UserManager.shared.deleteFriend(ownerID: Auth.auth().currentUser?.uid ?? "", userID: userid)
                self.successAlert()
            })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func confirm(userid: String) {
        // 建立一個提示框
        let dataBase = Firestore.firestore()

        let alertController = UIAlertController(
            title: "BlockUser",
            message: "Are you sure you want to block this user？",
            preferredStyle: .alert)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: "YES",
            style: .default,
            handler: { _ in
                dataBase.collection("user").document(Auth.auth().currentUser?.uid ?? "").updateData([
                    "blockList": FieldValue.arrayUnion([userid])
                ])
                self.successAlert()
                UserManager.shared.deleteFriend(ownerID: Auth.auth().currentUser?.uid ?? "", userID: userid)
                UserManager.shared.deleteFriend(ownerID: userid, userID: Auth.auth().currentUser?.uid ?? "")
            
            })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func successAlert() {
        let alertController = UIAlertController(
            title: "Success",
            message: "",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)

        self.present(
            alertController,
            animated: true,
            completion: nil)
    }

}

extension FriendsListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FriendListCell") as? FriendListCell
        else { return UITableViewCell() }
        cell.unfollowBtn.isHidden = true
        cell.backgroundColor = .clear
        cell.friendImage.kf.setImage(with: URL(string: friendList[indexPath.row].userImage))
        cell.nameLb.text = friendList[indexPath.row].name
        cell.delegate = self
        
        return cell
    }
   
}

extension FriendsListVC: BlockUserDelegate {
    func tapToBlock(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        self.confirm(userid: friendList[indexPath.row].userID)
//        friendList.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .left)
        
    }
}

extension FriendsListVC: UnfollowDelegate {
    func tapToUnfollow(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        self.confirmUnfollow(userid: friendList[indexPath.row].userID)
    }
    
}
