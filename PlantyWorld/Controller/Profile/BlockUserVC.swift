//
//  BlockUserVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/6.
//

import Foundation
import UIKit
import FirebaseAuth

class BlockUserVC: UIViewController {
    
    var tableView = UITableView()
    var titleLb = UILabel()
    var userData: User?
    var blockList: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        getBlockList()
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
        titleLb.text = "FOLLOWING USER"
        titleLb.font = UIFont(name: "Marker Felt", size: 32)
        
        tableView.backgroundColor = .clear
        tableView.anchor(top: titleLb.bottomAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
    }
    
    func getBlockList() {
        self.blockList.removeAll()
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
}

extension BlockUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "FriendListCell") as? FriendListCell
        else { return UITableViewCell() }
        cell.blockBtn.isHidden = true
        cell.unfollowBtn.setTitle("UNBLOCK", for: .normal)
        cell.backgroundColor = .clear
        cell.friendImage.kf.setImage(with: URL(string: blockList[indexPath.row].userImage))
        cell.nameLb.text = blockList[indexPath.row].name
        return cell
    }
    
}
