//
//  AccountManagerVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/5.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class AccountManagerVC: UIViewController {
    
    var stackView = UIStackView()
    var logoutBtn = UIButton()
    var deleteAccountBtn = UIButton()
    var privacyBtn = UIButton()
    var friendList = UIButton()
    var userData: User?
    var blockUser = UIButton()
    let dataBase = Firestore.firestore()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "286765a6ce7d6835bcf31047ca916f1d")!)
        setupStackView()
        setBtnUI()
        btnFunc()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(friendList)
        stackView.addArrangedSubview(blockUser)
        stackView.addArrangedSubview(logoutBtn)
        stackView.addArrangedSubview(privacyBtn)
        stackView.addArrangedSubview(deleteAccountBtn)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.anchor(width: 300, height: 400)
        stackView.centerY(inView: view)
        stackView.centerX(inView: view)
    }
    
    func setBtnUI() {
        logoutBtn.anchor(width: 200, height: 55)
        logoutBtn.setTitle("LOGOUT", for: .normal)
        logoutBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        logoutBtn.backgroundColor = .lightPeach
        logoutBtn.layer.cornerRadius = 20
        logoutBtn.setTitleColor(.trygreen, for: .normal)
        
        friendList.anchor(width: 200, height: 55)
        friendList.setTitle("FOLLOW LIST", for: .normal)
        friendList.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        friendList.backgroundColor = .lightPeach
        friendList.layer.cornerRadius = 20
        friendList.setTitleColor(.trygreen, for: .normal)
        
        deleteAccountBtn.anchor(width: 200, height: 55)
        deleteAccountBtn.setTitle("DELETE ACCOUNT", for: .normal)
        deleteAccountBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        deleteAccountBtn.backgroundColor = .lightPeach
        deleteAccountBtn.layer.cornerRadius = 20
        deleteAccountBtn.setTitleColor(.systemRed, for: .normal)

        privacyBtn.anchor(width: 200, height: 55)
        privacyBtn.setTitle("PRIVACY POLICY", for: .normal)
        privacyBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        privacyBtn.backgroundColor = .lightPeach
        privacyBtn.layer.cornerRadius = 20
        privacyBtn.setTitleColor(.trygreen, for: .normal)

        blockUser.anchor(width: 200, height: 55)
        blockUser.setTitle("BLOCKED USERS", for: .normal)
        blockUser.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        blockUser.backgroundColor = .lightPeach
        blockUser.layer.cornerRadius = 20
        blockUser.setTitleColor(.trygreen, for: .normal)

    }
    
    func btnFunc() {
        logoutBtn.addTarget(self, action: #selector(tapToLogout), for: .touchUpInside)
        deleteAccountBtn.addTarget(self, action: #selector(deleteuser), for: .touchUpInside)
        privacyBtn.addTarget(self, action: #selector(goWebVC), for: .touchUpInside)
        blockUser.addTarget(self, action: #selector(goBlockVC), for: .touchUpInside)
        friendList.addTarget(self, action: #selector(goFLiistVC), for: .touchUpInside)
//        blockUser.addTarget(self, action: #selector(crash), for: .touchUpInside)
    }
    
    @objc func crash() {
        fatalError()
    }
    
    @objc func goFLiistVC() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginVC()
            loginVC.modalPresentationStyle = .overFullScreen
            navigationController?.present(loginVC, animated: true, completion: nil)
//            navigationController?.pushViewController(loginVC, animated: true)
        } else {
            let nextVC = FriendsListVC()
            nextVC.userID = self.userData?.userID ?? ""
            nextVC.modalPresentationStyle = .overFullScreen
            navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    @objc func goBlockVC() {
        let nextVC = BlockUserVC()
        nextVC.userID = self.userData?.userID ?? ""
        nextVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc func goWebVC() {
        let nextVC = WebVC()
        present(nextVC, animated: true)
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
    
    func deleteDate(uid: String ) {
        let documentRef = dataBase.collection("user").document(uid)
        documentRef.delete()
        print("deleted user!!")
    }
    
    func deletePlantsDate(uid: String) {
        let documentRef = dataBase.collection("plants").whereField("userID", isEqualTo: uid).getDocuments { querySnapshot, error in
            if error != nil {
                print("Error")
            } else {
                guard let querySnapshot = querySnapshot else {
                    return
                }
                for doc in querySnapshot.documents {
                    doc.reference.delete()
                }
            }
        }
    }
    
    @objc func deleteuser() {
        let alert  = UIAlertController(title: "Delete Account",
                                       message: "Are you sure you want to delete your account?",
                                       preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .destructive) { (_) in
            self.deleteAccount()
            self.deletePlantsDate(uid: self.userData?.userID ?? "")
            self.deleteDate(uid: self.userData?.userID ?? "")
            self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.viewWillAppear(true)
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(noAction)
        alert.addAction(yesAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func deleteAccount() {
        UserManager.shared.deleteUser()

    }
    
}
