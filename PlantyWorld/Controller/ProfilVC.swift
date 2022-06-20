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
    
    override func viewDidLoad() {
        userBackground.addSubview(userImage)
        setup()
        self.navigationItem.title = "Profile"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userBackground.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        userBackground.layoutIfNeeded()
        userImage.layer.cornerRadius = 92
        userImage.layer.masksToBounds = true
    }
    
    func setup() {
        view.addSubview(userBackground)
        view.addSubview(userName)
        
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
                
    }
    
}
