//
//  ProfilVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/20.
//

import Foundation
import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    var userId: String = ""
    
    var backView = UIView()
    
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
    
    var logoutBtn = UIButton()
    
    var userData: User?
    
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.userPlants.text = " 我有\(self.plantList.count)顆植物 "
                self.userName.text = " \(self.userData?.userID ?? "") "
            }
        }
    }
    
    override func viewDidLoad() {
        view.addSubview(backView)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Soft")!)
        self.navigationItem.title = "Profile"
        setup()
        setUI()
        getData()
        levelColor()
        setBtn()
        setUserImage()
        setLogout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        userBackground.layoutIfNeeded()
        getData()
        levelColor()
        getUserData()
        
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
        } else {
            return
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        userBackground.layoutIfNeeded()
        userImage.layer.cornerRadius = 117
        userImage.layer.masksToBounds = true
    }
    
    func setLogout() {
        view.addSubview(logoutBtn)
        logoutBtn.isEnabled = true
        logoutBtn.anchor(top: view.topAnchor, right: view.rightAnchor,
                         paddingTop: 100, paddingRight: 20)
        logoutBtn.setTitle(" LOG OUT ", for: .normal)
        logoutBtn.backgroundColor = .dPeach
        logoutBtn.addTarget(self, action: #selector(tapToLogout), for: .touchUpInside)
//        logoutBtn.addTarget(self, action: #selector(tapToLogout), for: .touchUpInside)
    }
    
    @objc func tapToLogout() {
            let controller = UIAlertController(title: "登出提醒", message: "確定要登出嗎?", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "確定", style: .default) { _ in

                do {

                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                    print("sign outtttt")

                } catch let signOutError as NSError {

                   print("Error signing out: \(signOutError)")

                }
            }

            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

            controller.addAction(okAction)

            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
        }

    func setup() {
        backView.addSubview(userBackground)
        backView.addSubview(userName)
        
        backView.addSubview(levelBG)
        backView.addSubview(userPlantsBG)
        backView.addSubview(addFBG)
        
        backView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                        right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                        paddingRight: 0, height: UIScreen.height * 2/3)
        backView.backgroundColor = .lightYellow
        backView.layer.cornerRadius = 40
    
        levelBG.addSubview(levelLb)
        userPlantsBG.addSubview(userPlants)
        userPlantsBG.addSubview(plantsImage)
        addFBG.addSubview(addFriendBtn)
        
        userName.anchor(top: userBackground.bottomAnchor, paddingTop: 16)
        userName.centerX(inView: view)
        userName.text = "User Name"
        
        levelBG.anchor(top: userName.bottomAnchor, paddingTop: 12, width: 250, height: 50)
        levelBG.centerX(inView: view)
        levelLb.textColor = .white

        userPlantsBG.anchor(top: levelBG.bottomAnchor, paddingTop: 12, width: 250, height: 50)
        userPlantsBG.centerX(inView: view)
       
        addFBG.anchor(top: userPlantsBG.bottomAnchor, paddingTop: 12, width: 250, height: 50)
        addFBG.centerX(inView: view)

        levelLb.anchor(top: levelBG.topAnchor, left: levelBG.leftAnchor,
                       bottom: levelBG.bottomAnchor, right: levelBG.rightAnchor,
                       paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        plantsImage.anchor(top: userPlantsBG.topAnchor, left: userPlantsBG.leftAnchor,
                           bottom: userPlantsBG.bottomAnchor, paddingTop: 2,
                           paddingLeft: 8, paddingBottom: 2, width: 50)
        userPlants.anchor(top: userPlantsBG.topAnchor, left: plantsImage.rightAnchor,
                          bottom: userPlantsBG.bottomAnchor, right: userPlantsBG.rightAnchor,
                          paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userPlants.textColor = .white
        
    }
    
    func setUserImage() {
        
        userBackground.addSubview(userImage)
        userBackground.backgroundColor = .systemYellow
        userBackground.layer.cornerRadius = 125
        
        userBackground.centerX(inView: view)
        userBackground.anchor(top: view.topAnchor, paddingTop: UIScreen.height * 5/24, width: 250, height: 250)
        
        userImage.anchor(top: userBackground.topAnchor, left: userBackground.leftAnchor,
                         bottom: userBackground.bottomAnchor, right: userBackground.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userImage.image = UIImage(named: "山烏龜")
        userImage.contentMode = .scaleToFill
        
    }
    
    func setBtn() {
        
        addFriendBtn.anchor(top: addFBG.topAnchor, left: addFBG.leftAnchor,
                            bottom: addFBG.bottomAnchor, right: addFBG.rightAnchor,
                            paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
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
        FirebaseManager.shared.fetchData(uid: userUid, completion: { plantList in self.plantList = plantList ?? [] })
        print(plantList.count)
    }
    
    func getUserData() {
        UserManager.shared.fetchUserData(userID: userUid) { result in
            switch result {
            case let .success(user):
                print("get data")
                self.userData = user
            case .failure:
                print("failure")
            }
        }
    }
    
    @objc func goAddFriendVC() {
//        let addFriendVC = AddFriendVC()
//        navigationController?.pushViewController(addFriendVC, animated: true)
//        let addCommandVC = AddCommandVC()
    
        let loginVC = LoginVC()
//        navigationController?.pushViewController(loginVC, animated: true)
        loginVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(loginVC, animated: true, completion: nil)
        
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
