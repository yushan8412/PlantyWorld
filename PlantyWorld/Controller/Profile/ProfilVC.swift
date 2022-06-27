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
    
    var levelBG = UIView()
    var levelLb = UILabel()
    
    var userPlants = UILabel()
    var userPlantsBG = UIView()
    var plantsImage = UIImageView()
    
    var addFBG = UIView()
    var addFriendBtn = UIButton()
    
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.userPlants.text = " 我有\(self.plantList.count)顆植物 "
                self.userName.text = " \(self.plantList[0].author.id) "
            }
        }
    }
    
    override func viewDidLoad() {
        userBackground.addSubview(userImage)
        view.backgroundColor = .lightYellow
        setup()
        setUI()
        self.navigationItem.title = "Profile"
        getData()
        levelColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        userBackground.layoutIfNeeded()
        getData()
        levelColor()
    
    }
    
    override func viewDidLayoutSubviews() {
        userBackground.layoutIfNeeded()
        userImage.layer.cornerRadius = 117
        userImage.layer.masksToBounds = true
    }
    
    func setup() {
        view.addSubview(userBackground)
        view.addSubview(userName)
//        view.addSubview(userPlants)
//        view.addSubview(addFriendBtn)
//        view.addSubview(levelLb)
        
        view.addSubview(levelBG)
        view.addSubview(userPlantsBG)
        view.addSubview(addFBG)
        
        levelBG.addSubview(levelLb)
        userPlantsBG.addSubview(userPlants)
        userPlantsBG.addSubview(plantsImage)
        addFBG.addSubview(addFriendBtn)
        
        
        userBackground.backgroundColor = .systemYellow
        userBackground.layer.cornerRadius = 125
        
        userBackground.centerX(inView: view)
        userBackground.anchor(top: view.topAnchor, paddingTop: 120, width: 250, height: 250)
        
        userImage.anchor(top: userBackground.topAnchor, left: userBackground.leftAnchor,
                         bottom: userBackground.bottomAnchor, right: userBackground.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userImage.image = UIImage(named: "山烏龜")
        userImage.contentMode = .scaleToFill
        
        userName.anchor(top: userBackground.bottomAnchor, paddingTop: 16)
        userName.centerX(inView: view)
        userName.text = "User Name"
        
        levelBG.anchor(top: userName.bottomAnchor, paddingTop: 12, width: 250, height: 80)
        levelBG.centerX(inView: view)

        userPlantsBG.anchor(top: levelBG.bottomAnchor, paddingTop: 12, width: 250, height: 80)
        userPlantsBG.centerX(inView: view)
       
        addFBG.anchor(top: userPlantsBG.bottomAnchor, paddingTop: 12, width: 250, height: 80)
        addFBG.centerX(inView: view)

        levelLb.anchor(top: levelBG.topAnchor, left: levelBG.leftAnchor,
                       bottom: levelBG.bottomAnchor, right: levelBG.rightAnchor,
                       paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        plantsImage.anchor(top: userPlantsBG.topAnchor, left: userPlantsBG.leftAnchor,
                           bottom: userPlantsBG.bottomAnchor, paddingTop: 8,
                           paddingLeft: 8, paddingBottom: 8, width: 60)
        userPlants.anchor(top: userPlantsBG.topAnchor, left: plantsImage.rightAnchor,
                          bottom: userPlantsBG.bottomAnchor, right: userPlantsBG.rightAnchor,
                          paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        addFriendBtn.anchor(top: addFBG.topAnchor, left: addFBG.leftAnchor, bottom: addFBG.bottomAnchor, right: addFBG.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        
//        levelLb.backgroundColor = .twitterBlue
//        levelLb.text = "123123"
//
//        userPlants.anchor(top: levelLb.bottomAnchor, paddingTop: 16)
//        userPlants.centerX(inView: view)
//        userPlants.backgroundColor = .systemYellow
//
//        addFriendBtn.anchor(top: userPlants.bottomAnchor, paddingTop: 16)
//        addFriendBtn.centerX(inView: view)
        addFriendBtn.setTitle(" + ADD FRIEND", for: .normal)
        addFriendBtn.tintColor = .black
        addFriendBtn.addTarget(self, action: #selector(goAddFriendVC), for: .touchUpInside)
        
    }
    
    func setUI() {
        
        levelBG.backgroundColor = .pgreen
        levelBG.layer.cornerRadius = 20
        levelBG.layer.borderWidth = 0.5
        
        userPlantsBG.backgroundColor = .pgreen
        userPlantsBG.layer.cornerRadius = 20
        userPlantsBG.layer.borderWidth = 0.5
        
        addFBG.backgroundColor = .pgreen
        addFBG.layer.cornerRadius = 20
        addFBG.layer.borderWidth = 0.5
        
        levelLb.font = UIFont(name: "Helvetica-Light", size: 24)
        plantsImage.image = UIImage(named: "plant-pot")
    }
    
    func getData() {
        FirebaseManager.shared.fetchData(completion: { plantList in self.plantList = plantList ?? [] })
        print(plantList.count)
    }
    
    @objc func goAddFriendVC() {
        let addFriendVC = AddFriendVC()
        navigationController?.pushViewController(addFriendVC, animated: true)

    }
    
    func levelColor() {
        if plantList.count < 5 {
            userBackground.backgroundColor = .gray
            levelLb.text = " Level：Green Finger "
        } else if plantList.count >= 5 {
            userBackground.backgroundColor = .blue
            levelLb.text = " Level：Green Finger "
        } else if plantList.count >= 10 {
            userBackground.backgroundColor = .red
            levelLb.text = "Level：小園丁"
        } else if plantList.count >= 15 {
            userBackground.backgroundColor = .systemYellow
            levelLb.text = "Level：綠手指"
        }
    }
}
