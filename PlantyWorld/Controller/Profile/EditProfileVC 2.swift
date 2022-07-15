//
//  EditProfileVC.swift
//  PlantyWorld
//
//  Created by Yushan Yang on 2022/6/29.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class EditProfileVC: UIViewController {
    
    var userImage = UIImageView()
    var nameLB = UILabel()
    var emailLB = UILabel()
    var email = UILabel()
    var userTF = UITextField()
    var addPicBtn = UIButton()
    var comfirmBtn = UIButton()
    var backBtn = UIButton(type: .close)
    let addPic = UIImage(named: "add-photo")
    var userData: User?

    override func viewDidLoad() {
        view.layoutIfNeeded()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg4")!)
        setup()
        setBtnUp()
        userTF.layer.cornerRadius = 10
        email.layer.cornerRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showPic()
    }
    
    override func viewDidLayoutSubviews() {
        view.layoutIfNeeded()
        
    }
    
    func setup() {
        view.addSubview(userImage)
        view.addSubview(nameLB)
        view.addSubview(userTF)
        view.addSubview(backBtn)
        view.addSubview(comfirmBtn)
        view.addSubview(addPicBtn)
        view.addSubview(emailLB)
        view.addSubview(email)
        
        userImage.centerX(inView: view)
        userImage.anchor(top: view.topAnchor, paddingTop: 180, width: 250, height: 250)
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 30
        
        nameLB.anchor(top: userImage.bottomAnchor, paddingTop: 16)
        nameLB.centerX(inView: view)
        nameLB.textColor = .black
        nameLB.text = " Your Name "
        nameLB.font = UIFont(name: "Chalkboard SE", size: 24)
        
        userTF.anchor(top: nameLB.bottomAnchor, paddingTop: 16, width: 200, height: 40)
        userTF.centerX(inView: view)
        userTF.backgroundColor = .white
        userTF.textColor = .black
        userTF.text = "\(userData?.name ?? "")"
        userTF.placeholder = "Name"
        userTF.layer.borderWidth = 0.5

        emailLB.anchor(top: userTF.bottomAnchor, paddingTop: 16)
        emailLB.centerX(inView: view)
        emailLB.text = "Email"
        emailLB.textColor = .black
        emailLB.font = UIFont(name: "Chalkboard SE", size: 24)

        email.anchor(top: emailLB.bottomAnchor, paddingTop: 16, width: 300, height: 40)
        email.centerX(inView: view)
        email.text = "\(userData?.useremail ?? "")"
        email.textColor = .darkGray
        email.backgroundColor = .white
        email.layer.borderWidth = 0.5
        
        backBtn.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 48, paddingRight: 24)
        backBtn.backgroundColor = .black
        backBtn.layer.cornerRadius = 15
        
        comfirmBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 24)
        comfirmBtn.centerX(inView: view)
        comfirmBtn.setTitle("Comfirm", for: .normal)
        comfirmBtn.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 24)
        comfirmBtn.backgroundColor = .dPeach
        
        addPicBtn.anchor(bottom: userImage.bottomAnchor, right:
                            userImage.rightAnchor, paddingBottom: 8, paddingRight: 8)
        addPicBtn.setImage(addPic, for: .normal)
        addPicBtn.tintColor = .black
        
    }
    
    func setBtnUp() {
        
        backBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        addPicBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
        comfirmBtn.addTarget(self, action: #selector(tapToUpdate), for: .touchUpInside)
    }
    
    func lottie() {
        let animationView = loadAnimation(name: "51686-a-botanical-wreath-loading", loopMode: .loop)
        animationView.play()

    }
    
    @objc func dismissVC() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadFrom() {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "開啟相機拍照", style: .default) { (_) in
            self.camera()
        }
        let libraryAction = UIAlertAction(title: "從相簿中選擇", style: .default) { (_) in
            self.photopicker()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cameraAction)
        controller.addAction(libraryAction)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }
    }
    
    func photopicker() {
        let photoController = UIImagePickerController()
        photoController.delegate = self
        photoController.sourceType = .photoLibrary
        present(photoController, animated: true, completion: nil)
    }
    
    func showPic() {
        if userData?.userImage != "no image yet" {
            self.userImage.kf.setImage(with: URL(string: userData?.userImage ?? ""))
        } else {
            self.userImage.image = UIImage(named: "About us")
        }
    }
    
    @objc func tapToUpdate() {
        
        let imageData = self.userImage.image!.jpegData(compressionQuality: 0.3)
        guard imageData != nil else {
            return
        }
        let fileReference = Storage.storage().reference().child(UUID().uuidString + ".jpg")
        if let data  = imageData {
            fileReference.putData(data, metadata: nil) { result in
                switch result {
                case .success:
                    fileReference.downloadURL { [self] result in
                        switch result {
                        case .success(let url):
                            UserManager.shared.updateUserInfo(uid: Auth.auth().currentUser?.uid ?? "", image: "\(url)", name: userTF.text ?? "empty name") { result in
                                switch result {
                                case .success:
                                    self.dismissVC()
                                    print("update user info")
                                case .failure:
                                    print("ERRRRRROR")
                                }
                                
                            }
                            
                        case .failure:
                            break
                        }
                    }
                case .failure:
                    break
                }
            }
            
        }
        self.comfirmBtn.isEnabled = false
        self.lottie()
        PlantDetailVC().viewWillAppear(true)
    }
    
    func lodingPic() {
        
    }
    
}

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            
            DispatchQueue.main.async {
                self.userImage.image = image
            }
        } else {
            print("沒有選到相片")
        }
        dismiss(animated: true, completion: nil)
    }
    
}
