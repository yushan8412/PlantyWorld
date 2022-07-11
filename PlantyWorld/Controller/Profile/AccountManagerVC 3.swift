//
//  AccountManagerVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/7/5.
//

import Foundation
import UIKit
import FirebaseAuth

class AccountManagerVC: UIViewController {
    
    var stackView = UIStackView()
    var logoutBtn = UIButton()
    var deleteAccountBtn = UIButton()
    var privacyBtn = UIButton()
    var userData: User?
    var blockUser = UIButton()
    
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
        stackView.addArrangedSubview(logoutBtn)
        stackView.addArrangedSubview(blockUser)
        stackView.addArrangedSubview(privacyBtn)
        stackView.addArrangedSubview(deleteAccountBtn)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.anchor(width: 300, height: 300)
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
//        blockUser.addTarget(self, action: #selector(crash), for: .touchUpInside)
    }
    
    
    @objc func crash() {
        fatalError()
    }
    
    @objc func goBlockVC() {
        let nextVC = BlockUserVC()
        nextVC.userData = self.userData
        nextVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc func goWebVC() {
        let nextVC = WebVC()
        nextVC.modalPresentationStyle = .overFullScreen
        navigationController?.pushViewController(nextVC, animated: true)
        
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
                self.viewWillAppear(true)
            }

            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

            controller.addAction(okAction)

            controller.addAction(cancelAction)

            present(controller, animated: true, completion: nil)
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
    
}
