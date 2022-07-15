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
    var waterBtn = UIButton()
    var editBtn = UIButton()
    let addPic = UIImage(named: "edit-image")
    var deleteUserBtn = UIButton()
    var btnStackView = UIStackView()
    var userData: User?
    
    var plantList: [PlantsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.userPlants.text = " GOT \(self.plantList.count) PLANTS "
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
        setupStackView()
        levelColor()
        setNEditBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        
        userBackground.layoutIfNeeded()
        getData()
        getUserData()
        levelColor()
        
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
        btnStackView.addArrangedSubview(waterBtn)
        btnStackView.addArrangedSubview(deleteUserBtn)
        
        btnStackView.axis = .vertical
        btnStackView.distribution = .equalSpacing
        
//        btnStackView.anchor(top: userName.bottomAnchor, bottom: view.bottomAnchor,
//                            paddingTop: 16, paddingBottom: view.safeAreaInsets.bottom)
//        print(view.safeAreaInsets.bottom)
        btnStackView.anchor(top: userName.bottomAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            paddingTop: 16, paddingBottom: 16)
        btnStackView.centerX(inView: view)
              
        userPlantsBG.anchor(width: 260, height: UIScreen.height/17)
        userPlantsBG.centerX(inView: view)
       
        addFBG.anchor(width: 260, height: UIScreen.height/17)
        
        waterBtn.anchor(width: 260, height: UIScreen.height/17)
        waterBtn.setTitle("WATERING REMINDER", for: .normal)
        waterBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 22)
        
        deleteUserBtn.anchor(width: 260, height: UIScreen.height/17)
        deleteUserBtn.setTitle("ACCOUNT MANAGER", for: .normal)
        deleteUserBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 22)
        
        userPlantsBG.addSubview(plantsImage)
        plantsImage.anchor(top: userPlantsBG.topAnchor, left: userPlantsBG.leftAnchor,
                           bottom: userPlantsBG.bottomAnchor, paddingTop: 8,
                           paddingLeft: 8, paddingBottom: 8, width: 35)
        userPlantsBG.addSubview(userPlants)
        userPlants.anchor(top: userPlantsBG.topAnchor, left: plantsImage.rightAnchor,
                          bottom: userPlantsBG.bottomAnchor, right: userPlantsBG.rightAnchor,
                          paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8)
        userPlants.textColor = .white
        userPlants.font = UIFont(name: "Chalkboard SE", size: 24)
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
        
        userName.anchor(top: userBackground.bottomAnchor, paddingTop: 4, height: 30)
        userName.centerX(inView: view)
        userName.textColor = .darkGray
        userName.font = UIFont(name: "Chalkboard SE", size: 24)
        userName.setContentHuggingPriority(UILayoutPriority(255), for: .vertical)
        
    }
    
    func setUserImage() {
        view.addSubview(userImage)
        userBackground.addSubview(userImage)
        userBackground.backgroundColor = .systemYellow
        userBackground.layer.cornerRadius = 125
        
        userBackground.centerX(inView: view)
        userBackground.anchor(top: view.topAnchor, paddingTop: UIScreen.height * 3/16, width: 250, height: 250)
        
        userImage.anchor(top: userBackground.topAnchor, left: userBackground.leftAnchor,
                         bottom: userBackground.bottomAnchor, right: userBackground.rightAnchor,
                         paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        
    }
    
    func setNEditBtn() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
                    image: UIImage(named: "Group")?
                        .withTintColor(UIColor.black)
                        .withRenderingMode(.alwaysOriginal),
                    style: .plain,
                    target: self,
                    action: #selector(goEditVC))
    }
    
    func setBtn() {
        addFBG.addSubview(addFriendBtn)
        addFriendBtn.anchor(top: addFBG.topAnchor, left: addFBG.leftAnchor,
                            bottom: addFBG.bottomAnchor, right: addFBG.rightAnchor,
                            paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8)
        
        addFriendBtn.setTitle(" + FOLLOW ", for: .normal)
        addFriendBtn.tintColor = .black
        addFriendBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        addFriendBtn.addTarget(self, action: #selector(goAddFriendVC), for: .touchUpInside)
        
        waterBtn.addTarget(self, action: #selector(goDatePickerVC), for: .touchUpInside)
        deleteUserBtn.addTarget(self, action: #selector(goManagerVC), for: .touchUpInside)

    }
    
    func setUI() {

        userPlantsBG.backgroundColor = .trygreen
        userPlantsBG.layer.cornerRadius = 20
        userPlantsBG.layer.borderWidth = 0.5
        
        addFBG.backgroundColor = .trygreen
        addFBG.layer.cornerRadius = 20
        addFBG.layer.borderWidth = 0.5
        
        waterBtn.backgroundColor = .trygreen
        waterBtn.layer.cornerRadius = 20
        waterBtn.layer.borderWidth = 0.5
        
        deleteUserBtn.backgroundColor = .trygreen
        deleteUserBtn.layer.cornerRadius = 20
        deleteUserBtn.layer.borderWidth = 0.5
        
        plantsImage.image = UIImage(named: "plant-pot")
    }
    
    @objc func goDatePickerVC() {
        let nextVC = WaterReminderVC()
    
        nextVC.modalPresentationStyle = .overFullScreen
        navigationController?.present(nextVC, animated: true, completion: nil)
    }
    
    @objc func goManagerVC() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
//            loginVC.delegate = self
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
        } else {
        let nextVC = AccountManagerVC()
        nextVC.userData = self.userData
        nextVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(nextVC, animated: true)
        }
    }
        
    @objc func goEditVC() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
        } else {
        let editVC = EditProfileVC()
        editVC.userData = self.userData
        editVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(editVC, animated: true)
        }
    }
    
    @objc func tapToLogout() {
            let controller = UIAlertController(title: "LOGOUT", message: "Are you sure you want to logout?", preferredStyle: .alert)

            let okAction = UIAlertAction(title: "YES", style: .default) { _ in

                do {

                    try Auth.auth().signOut()
                    self.navigationController?.popToRootViewController(animated: true)
                    userUid = ""
                    print("sign outtttt")

                } catch let signOutError as NSError {

                   print("Error signing out: \(signOutError)")

                }
                self.viewWillAppear(true)
            }

            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            controller.addAction(okAction)

            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
    }
    
    func getData() {
        FirebaseManager.shared.fetchUserPlantsData(uid: Auth.auth().currentUser?.uid ?? "", completion: { plantList in self.plantList = plantList
            self.levelColor()
        })
    }
    
    func getUserData() {

        if Auth.auth().currentUser != nil {
            
            UserManager.shared.fetchUserData(userID: Auth.auth().currentUser?.uid ?? "") { result in
                switch result {
                case let .success(user):
                    print("get data")
                    self.userData = user
                    if self.userData?.userImage != "" {
                    self.userImage.kf.setImage(with: URL(string: self.userData?.userImage ?? ""))
                    } else {
                        self.userImage.image = UIImage(named: "About us")
                    }
                    self.userName.text = self.userData?.name ?? "something went wrong"
                case .failure:
                    print("failure")
                }
            }
        } else {
            self.userImage.image = UIImage(named: "About us")
            self.userName.text = "User Name"
        }
    }
        
    @objc func deleteuser() {
        let alert  = UIAlertController(title: "Delete Account",
                                       message: "Are you sure you want to delete your account?",
                                       preferredStyle: .alert)
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
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
        } else {
        let addFriendVC = AddFriendVC()
        addFriendVC.userDate = self.userData
        navigationController?.pushViewController(addFriendVC, animated: true)
        }
    }
    
    func levelColor() {
        if plantList.count < 5 {
            userBackground.backgroundColor = .gray
        } else if plantList.count >= 5 {
            userBackground.backgroundColor = .pyellow
        } else if plantList.count >= 10 {
            userBackground.backgroundColor = .peach
        } else if plantList.count >= 15 {
            userBackground.backgroundColor = .lightYellow
        }
    }
}

// extension ProfileVC: OpenEditVCDelegate {
//    func askVCopen() {
//        let nextVC = EditProfileVC()
//        nextVC.email.text = Auth.auth().currentUser?.email
//        print(Auth.auth().currentUser?.email)
//        nextVC.userImage.image = UIImage(named: "About us")
//        self.navigationController?.present(nextVC, animated: true)
//    }
// }
