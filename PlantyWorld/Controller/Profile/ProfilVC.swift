//
//  ProfilVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/20.
//

import Foundation
import UIKit
import FirebaseAuth
import Kingfisher

class ProfileVC: UIViewController {
    
    var userId: String = ""
    
    var backView = UIView()
    
    var userImage = UIImageView()
    var userBackground = UIView()
    var userName = UILabel()
    
    var userPlants = UILabel()
    var userPlantsBG = UIView()
    var plantsImage = UIImageView()
    
    var addFBG = UIView()
    var addFriendBtn = UIButton()
    
    var logoutBtn = UIButton()
    var editBtn = UIButton()
    let addPic = UIImage(named: "edit-image")
    
    var deleteUserBtn = UIButton()
    var btnStackView = UIStackView()
    
    var userData: User?
    
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.userPlants.text = " 我有\(self.plantList.count)顆植物 "
                self.userName.text = " \(self.userData?.name ?? "出事拉～") "
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
        setBtn()
        setUserImage()
        setEditBtn()
        setupStackView()
        levelColor()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        

        userBackground.layoutIfNeeded()
        getData()
        getUserData()
        levelColor()
        
        if userData?.userImage == "" {
            self.userImage.image = UIImage(named: "About us")
        } else {
            userImage.kf.setImage(with: URL(string: userData?.userImage ?? ""))
        }
        
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
            self.userName.text = "User Name"
            self.userImage.image = UIImage(named: "About us")
        } else {
            return
        }
    
    }
    
    override func viewDidLayoutSubviews() {
        userBackground.layoutIfNeeded()
        userImage.layer.cornerRadius = 117
        userImage.layer.masksToBounds = true
    }
    
    func setupStackView() {
        backView.addSubview(btnStackView)
        btnStackView.addArrangedSubview(userPlantsBG)
        btnStackView.addArrangedSubview(addFBG)
        btnStackView.addArrangedSubview(logoutBtn)
        btnStackView.addArrangedSubview(deleteUserBtn)
        
        btnStackView.axis = .vertical
        btnStackView.distribution = .equalSpacing
        
        btnStackView.anchor(top: userName.bottomAnchor, bottom: view.bottomAnchor,
                            paddingTop: 8, paddingBottom: 100)
        btnStackView.centerX(inView: view)
              
        userPlantsBG.anchor(width: 250, height: 50)
        userPlantsBG.centerX(inView: view)
       
        addFBG.anchor(width: 250, height: 50)
        
        logoutBtn.anchor(width: 250, height: 50)
        logoutBtn.setTitle(" LOG OUT ", for: .normal)
        
        deleteUserBtn.anchor(width: 250, height: 50)
        deleteUserBtn.setTitle(" DELETE ", for: .normal)
        
        userPlantsBG.addSubview(plantsImage)
        plantsImage.anchor(top: userPlantsBG.topAnchor, left: userPlantsBG.leftAnchor,
                           bottom: userPlantsBG.bottomAnchor, paddingTop: 2,
                           paddingLeft: 8, paddingBottom: 2, width: 50)
        userPlantsBG.addSubview(userPlants)
        userPlants.anchor(top: userPlantsBG.topAnchor, left: plantsImage.rightAnchor,
                          bottom: userPlantsBG.bottomAnchor, right: userPlantsBG.rightAnchor,
                          paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userPlants.textColor = .white
    }
    
    func setup() {
        backView.addSubview(userBackground)
        backView.addSubview(userName)
        
        backView.addSubview(userPlantsBG)
        backView.addSubview(addFBG)
        
        backView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                        right: view.rightAnchor, paddingLeft: 0, paddingBottom: 0,
                        paddingRight: 0, height: UIScreen.height * 2/3)
        backView.backgroundColor = .lightYellow
        backView.layer.cornerRadius = 40
        
        userName.anchor(top: userBackground.bottomAnchor, paddingTop: 8, height: 30)
        userName.centerX(inView: view)
        userName.text = "User Name"
        userName.textColor = .darkGray
        userName.backgroundColor = .black
        userName.setContentHuggingPriority(UILayoutPriority(255), for: .vertical)
        
    }
    
    func setUserImage() {
        view.addSubview(userImage)
        userBackground.addSubview(userImage)
        userBackground.backgroundColor = .systemYellow
        userBackground.layer.cornerRadius = 125
        
        userBackground.centerX(inView: view)
        userBackground.anchor(top: view.topAnchor, paddingTop: UIScreen.height * 5/24, width: 250, height: 250)
        
        userImage.anchor(top: userBackground.topAnchor, left: userBackground.leftAnchor,
                         bottom: userBackground.bottomAnchor, right: userBackground.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userImage.image = UIImage(named: "山烏龜")
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        
    }
    
    func setEditBtn() {
        view.addSubview(editBtn)
        editBtn.anchor(bottom: userBackground.bottomAnchor, right: userBackground.rightAnchor,
                       paddingBottom: 8, paddingRight: 32)
        editBtn.setImage(addPic, for: .normal)
        editBtn.addTarget(self, action: #selector(goEditVC), for: .touchUpInside)
    }
    
    func setBtn() {
        addFBG.addSubview(addFriendBtn)
        addFriendBtn.anchor(top: addFBG.topAnchor, left: addFBG.leftAnchor,
                            bottom: addFBG.bottomAnchor, right: addFBG.rightAnchor,
                            paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        addFriendBtn.setTitle(" + ADD FRIEND", for: .normal)
        addFriendBtn.tintColor = .black
        addFriendBtn.addTarget(self, action: #selector(goAddFriendVC), for: .touchUpInside)
        
        logoutBtn.addTarget(self, action: #selector(tapToLogout), for: .touchUpInside)
        deleteUserBtn.addTarget(self, action: #selector(deleteuser), for: .touchUpInside)

    }
    
    func setUI() {

        userPlantsBG.backgroundColor = .pgreen
        userPlantsBG.layer.cornerRadius = 20
        userPlantsBG.layer.borderWidth = 0.5
        
        addFBG.backgroundColor = .pgreen
        addFBG.layer.cornerRadius = 20
        addFBG.layer.borderWidth = 0.5
        
        logoutBtn.backgroundColor = .pgreen
        logoutBtn.layer.cornerRadius = 20
        logoutBtn.layer.borderWidth = 0.5
        
        deleteUserBtn.backgroundColor = .pgreen
        deleteUserBtn.layer.cornerRadius = 20
        deleteUserBtn.layer.borderWidth = 0.5
        
        plantsImage.image = UIImage(named: "plant-pot")
    }
    
    @objc func goEditVC() {
        let editVC = EditProfileVC()
        editVC.userData = self.userData
        editVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(editVC, animated: true, completion: nil)
        
    }
    
    @objc func tapToLogout() {
            let controller = UIAlertController(title: "登出提醒", message: "確定要登出嗎?", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "確定", style: .default) { _ in

                do {

                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                    userUid = ""
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
    
    func getData() {
        FirebaseManager.shared.fetchData(uid: Auth.auth().currentUser?.uid ?? "", completion: { plantList in self.plantList = plantList ?? [] })
        print(plantList.count)
    }
    
    func getUserData() {
        UserManager.shared.fetchUserData(userID: Auth.auth().currentUser?.uid ?? "") { result in
            switch result {
            case let .success(user):
                print("get data")
                self.userData = user
            case .failure:
                print("failure")
            }
        }
    }
    
    @objc func deleteuser() {
        let alert  = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .destructive) { (_) in
            self.deleteAccount()
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteAccount() {
        UserManager.shared.deleteUser()
        let loginVC = LoginVC()
        loginVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(loginVC, animated: true, completion: nil)
    }
    
    @objc func goAddFriendVC() {
        let addFriendVC = AddFriendVC()
        navigationController?.pushViewController(addFriendVC, animated: true)
        
//        let loginVC = LoginVC()
//        loginVC.modalPresentationStyle = .overFullScreen
//        navigationController?.present(loginVC, animated: true, completion: nil)
        
    }
    
    func levelColor() {
        if plantList.count < 5 {
            userBackground.backgroundColor = .gray
        } else if plantList.count >= 5 {
            userBackground.backgroundColor = .blue
        } else if plantList.count >= 10 {
            userBackground.backgroundColor = .red
        } else if plantList.count >= 15 {
            userBackground.backgroundColor = .systemYellow
        }
    }
}
