//
//  ProfilVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/20.
//

import Foundation
import UIKit
import SwiftUI

class ProfileVC: UIViewController {
    var userImage = UIImageView()
    var userBackground = UIView()
    var userName = UILabel()
    var userLevel = UILabel()
    var levelLb = UILabel()
    var addFriendBtn = UIButton()
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.userLevel.text = "我有\(self.plantList.count)顆植物"
            }
        }
    }
    
    override func viewDidLoad() {
        userBackground.addSubview(userImage)
        setup()
        self.navigationItem.title = "Profile"
        getData()
        levelColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        reloadInputViews()
        userBackground.layoutIfNeeded()
        getData()
        levelColor()
    
    }
    
    override func viewDidLayoutSubviews() {
        userBackground.layoutIfNeeded()
        userImage.layer.cornerRadius = 92
        userImage.layer.masksToBounds = true
    }
    
    func setup() {
        view.addSubview(userBackground)
        view.addSubview(userName)
        view.addSubview(userLevel)
        view.addSubview(addFriendBtn)
        view.addSubview(levelLb)
        
        userBackground.backgroundColor = .systemYellow
        userBackground.layer.cornerRadius = 100
        
        userBackground.centerX(inView: view)
        userBackground.anchor(top: view.topAnchor, paddingTop: 150, width: 200, height: 200)
        
        userImage.anchor(top: userBackground.topAnchor, left: userBackground.leftAnchor,
                         bottom: userBackground.bottomAnchor, right: userBackground.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userImage.image = UIImage(named: "山烏龜")
        userImage.contentMode = .scaleToFill
        
        userName.anchor(top: userBackground.bottomAnchor, paddingTop: 16)
        userName.centerX(inView: view)
        userName.text = "User Name"
        
        levelLb.anchor(top: userName.bottomAnchor, paddingTop: 16)
        levelLb.centerX(inView: view)
        levelLb.backgroundColor = .twitterBlue
        levelLb.text = "123123"
        
        userLevel.anchor(top: levelLb.bottomAnchor, paddingTop: 16)
        userLevel.centerX(inView: view)
        userLevel.backgroundColor = .systemYellow
        
        addFriendBtn.anchor(top: userLevel.bottomAnchor, paddingTop: 16)
        addFriendBtn.centerX(inView: view)
        addFriendBtn.setTitle(" + ADD FRIEND", for: .normal)
        addFriendBtn.backgroundColor = .systemYellow
        
    }
    
    func getData() {
        FirebaseManager.shared.fetchData(completion: { plantList in self.plantList = plantList ?? [] })
        print(plantList.count)
    }
    
    func levelColor() {
        if plantList.count < 5 {
            userBackground.backgroundColor = .gray
            levelLb.text = "Level：新人"
        } else if plantList.count >= 5 {
            userBackground.backgroundColor = .blue
            levelLb.text = "Level：小試身手"
        } else if plantList.count >= 10 {
            userBackground.backgroundColor = .red
            levelLb.text = "Level：小園丁"
        } else if plantList.count >= 15 {
            userBackground.backgroundColor = .systemYellow
            levelLb.text = "Level：綠手指"
        }
    }
}
