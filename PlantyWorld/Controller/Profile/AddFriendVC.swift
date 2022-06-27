//
//  AddFriendVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/23.
//

import Foundation
import UIKit
import SwiftUI

class AddFriendVC: UIViewController {
    
    
    var testBtn = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .lightOrange
        self.tabBarController?.tabBar.isHidden = true
        view.addSubview(testBtn)
        setBtn()
    }
    
    func setBtn() {
        testBtn.centerX(inView: view)
        testBtn.centerY(inView: view)
        testBtn.setTitle(" test ", for: .normal)
        testBtn.backgroundColor = .pgreen
        testBtn.addTarget(self, action: #selector(goNextVC), for: .touchUpInside)
        
    }
    
    @objc func goNextVC() {
        
        let loginVC = LoginVC()
                            
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
