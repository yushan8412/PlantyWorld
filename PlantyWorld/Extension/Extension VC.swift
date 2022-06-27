//
//  Extension VC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/27.
//

import Foundation
import UIKit
import FirebaseAuth

extension UIViewController {
    
    func showAlert(title: String, message: String, buttonTitle: String, vc: UIViewController) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        controller.addAction(okAction)
        vc.present(controller, animated: true, completion: nil)
        
    }
    
    func showLoginAlert() {
        
        let controller = UIAlertController(title: "請先登入", message: "登入會員才能使用這個功能喔！", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "登入", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(
                withIdentifier: String(describing: LoginVC.self))
            
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "稍後再說", style: .cancel, handler: nil)
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
}
