//
//  AddFriendVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/23.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Firebase

class AddFriendVC: UIViewController {
    
    var titleLB = UILabel()
    var searchBtn = UIButton()
    var searchTXF = UITextField()
    var tableView = UITableView()
    var friendData: User?
    var userDate: User?
    var qrImage = UIImageView()
    var scanBtn = UIButton()
    var isBlock = false
    var bigTitle = UILabel()
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "32e3a86d9a8999f0632a696f3500c675-1")!)
        self.tabBarController?.tabBar.isHidden = true
        view.addSubview(titleLB)
        view.addSubview(searchBtn)
        view.addSubview(searchTXF)
        view.addSubview(tableView)
        view.addSubview(qrImage)
        view.addSubview(scanBtn)
        view.addSubview(bigTitle)
        setup()
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    func setup() {
        bigTitle.anchor(bottom: qrImage.topAnchor, paddingBottom: 24)
        bigTitle.centerX(inView: view)
        bigTitle.text = "Follow Friends Plants"
        bigTitle.font = UIFont(name: "Chalkboard SE", size: 28)
        bigTitle.textColor = .black
        
        qrImage.anchor(bottom: titleLB.topAnchor, paddingBottom: 16, width: 200, height: 200)
        qrImage.centerX(inView: view)
        qrImage.image = generateQRCode(from: userDate?.useremail ?? "")
        
        scanBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 60, width: 60, height: 60)
        scanBtn.centerX(inView: view)
        scanBtn.setImage(UIImage(named: "scan"), for: .normal)
        scanBtn.addTarget(self, action: #selector(goScan), for: .touchUpInside)
        
        titleLB.anchor(bottom: searchTXF.topAnchor, paddingBottom: 16)
        titleLB.centerX(inView: view)
        titleLB.text = "Scan QRcode or"
        titleLB.textColor = .darkGray
        titleLB.font = UIFont(name: "Chalkboard SE", size: 24)
        titleLB.numberOfLines = 0
        titleLB.textAlignment = .center
        
        searchTXF.center(inView: view, yConstant: 100)
        searchTXF.anchor(width: 300, height: 40)
        searchTXF.backgroundColor = .white
        searchTXF.textColor = .black
        searchTXF.attributedPlaceholder =
        NSAttributedString(string: " Enter Your Friend's Email",
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        searchTXF.layer.borderWidth = 0.5
        searchTXF.layer.cornerRadius = 10
        
        searchBtn.anchor(top: searchTXF.bottomAnchor, paddingTop: 16)
        searchBtn.centerX(inView: view)
        searchBtn.setTitle(" Search ", for: .normal)
        searchBtn.backgroundColor = .pgreen
        searchBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        searchBtn.layer.cornerRadius = 20
        
        searchBtn.addTarget(self, action: #selector(searchFriend), for: .touchUpInside)

    }
    
    @objc func searchFriend() {
        self.checkEmail(email: searchTXF.text ?? "")
        self.searchTXF.text = ""
        
    }
    
    @objc func goScan() {
        let scanVC = ScanVC()
        scanVC.delegate = self
        navigationController?.pushViewController(scanVC, animated: true)
        
    }
    
    func checkEmail(email: String) {
        let dataBase = Firestore.firestore()
        
        // 在"user_data"collection裡，when the "email" in firebase is equal to chechEmail的參數email, than get that document.
        dataBase.collection("user").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, _ ) in
            
            if let querySnapshot = querySnapshot {
                if let document = querySnapshot.documents.first {
//                    self.confirm()
                    
                    for data in querySnapshot.documents {
                        let userdata = data.data(with: ServerTimestampBehavior.none)
                        let userName = userdata["name"] as? String ?? ""
                        let userEmail = userdata["email"] as? String ?? ""
                        let userID = userdata["id"] as? String ?? ""
                        let userImage = userdata["image"] as? String ?? ""
                        let followList = userdata["followList"] as? [String] ?? [""]
                        let blockList = userdata["blockList"] as? [String] ?? [""]

                        let user = User(userID:userID, name: userName, userImage: userImage,
                                        useremail: userEmail, followList: followList, blockList: blockList)
                        self.friendData = user
                        let blocklist = user.blockList
                        self.isBlock = blocklist.contains { (blockId) -> Bool in
                            blockId == self.friendData?.userID
                        }
                    }
                    print(document.data())
                    print("user is exist")
                    
                    let blocklist = self.userDate?.blockList ?? []
                    self.isBlock = blocklist.contains { (blockId) -> Bool in
                        blockId == self.friendData?.userID
                    }
                    
                    if self.isBlock == true {
                        let alertController = UIAlertController(
                            title: "Can not found this user",
                            message: "Check email again?",
                            preferredStyle: .alert)
                        let cancelAction = UIAlertAction(
                            title: "確認",
                            style: .cancel,
                            handler: nil)
                        alertController.addAction(cancelAction)

                        self.present(
                            alertController,
                            animated: true,
                            completion: nil)
                    } else if self.isBlock == false {
                        
                        self.confirm()
                    }
                        
                } else {
                   
                    let alertController = UIAlertController(
                        title: "Can not found this user",
                        message: "Check email again?",
                        preferredStyle: .alert)
                    let cancelAction = UIAlertAction(
                        title: "OK",
                        style: .cancel,
                        handler: nil)
                    alertController.addAction(cancelAction)

                    self.present(
                        alertController,
                        animated: true,
                        completion: nil)
                    
                    print("nobody here")
                    print(email)
                }
            }
        }
    }
    
    func successAlert() {
        let alertController = UIAlertController(
            title: "Success",
            message: "",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)

        self.present(
            alertController,
            animated: true,
            completion: nil)
    }
    
    func confirm() {
        // 建立一個提示框
        let dataBase = Firestore.firestore()

        let alertController = UIAlertController(
            title: "Follow Friend's Plants",
            message: "Add this user to your follow list？",
            preferredStyle: .alert)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: "YES",
            style: .default,
            handler: { _ in
                dataBase.collection("user").document(Auth.auth().currentUser?.uid ?? "").updateData([
                    "followList": FieldValue.arrayUnion([ "\(self.friendData?.userID ?? "")"])
                    // document.update -> don't have this member in document, so need to connect it with .reference
                    // arrayUnion -> same data can't be appent twice
                ])
                self.successAlert()
            })
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.present(
            alertController,
            animated: true,
            completion: nil)
    }

}

extension AddFriendVC: SendFriendDateDelegate {
    func getEmailValue(useremail: String) {
        DispatchQueue.main.async {
            self.searchTXF.text = useremail
            
        }
    }
    
}
