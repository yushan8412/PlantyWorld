//
//  BlockUserVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/6.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class BlockUserVC: UIViewController {
    
    var tableView = UITableView()
    var titleLb = UILabel()
    var userData: User?
    var userID = ""
    var blockList: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        getuserData()
        setupUI()
        view.backgroundColor = .peach
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FriendListCell", bundle: nil),
                                forCellReuseIdentifier: "FriendListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(titleLb)
        titleLb.anchor(top: view.topAnchor, paddingTop: 100)
        titleLb.centerX(inView: view)
        titleLb.text = "Blacklist"
        titleLb.font = UIFont(name: "Marker Felt", size: 32)
        
        tableView.backgroundColor = .clear
        tableView.anchor(top: titleLb.bottomAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
    }
    
    func getuserData() {
        self.blockList.removeAll()
        UserManager.shared.fetchUserData(userID: self.userID) { result in
            switch result {
            case .success(let user):
                self.userData = user
                self.getBlockList()
            case.failure:
                print("Error")
            }
        }
    }
    
    func getBlockList() {
        for userId in userData?.blockList ?? [] {
            UserManager.shared.fetchUserData(userID: userId) { result in
                switch result {
                case .success(let user):
                    self.blockList.append(user)
                case .failure:
                    print("Error")
                }
            }
        }
    }
    
    func confirm(userid: String) {
        // ?????????????????????
        let dataBase = Firestore.firestore()

        let alertController = UIAlertController(
            title: "Unblock User",
            message: "Are you sure you want to unblock this user???",
            preferredStyle: .alert)
        
        // ??????[??????]??????
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .destructive,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // ??????[??????]??????
        let okAction = UIAlertAction(
            title: "YES",
            style: .default,
            handler: { _ in
                dataBase.collection("user").document(Auth.auth().currentUser?.uid ?? "").updateData([
                    "blockList": FieldValue.arrayRemove([userid])
                ])
                self.successAlert()
                UserManager.shared.deleteFriend(ownerID: Auth.auth().currentUser?.uid ?? "", userID: userid)
                UserManager.shared.deleteFriend(ownerID: userid, userID: Auth.auth().currentUser?.uid ?? "")
            
            })
        alertController.addAction(okAction)
        
        // ???????????????
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
            handler: { _ in
                self.getuserData()
                self.tableView.reloadData()
            })
        alertController.addAction(cancelAction)

        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
}

extension BlockUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FriendListCell") as? FriendListCell
        else { return UITableViewCell() }
//        cell.unfollowBtn.isHidden = true
//        cell.blockBtn.setTitle("", for: .normal)
        cell.blockBtn.isHidden = true
        cell.unfollowBtn.setTitle("Unblock", for: .normal)
        cell.backgroundColor = .clear
        cell.friendImage.kf.setImage(with: URL(string: blockList[indexPath.row].userImage))
        cell.nameLb.text = blockList[indexPath.row].name
        cell.unfollowDelegate = self
        return cell
    }
    
}

extension BlockUserVC: UnfollowDelegate {
    func tapToUnfollow(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        self.confirm(userid: blockList[indexPath.row].userID)
    }
}
