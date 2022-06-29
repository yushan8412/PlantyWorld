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
    var userTF = UITextField()
    var addPicBtn = UIButton()
    var comfirmBtn = UIButton()
    var backBtn = UIButton(type: .close)
    let addPic = UIImage(named: "add-photo")

    override func viewDidLoad() {
        view.backgroundColor = UIColor(patternImage: UIImage(named: "bg4")!)
        setup()
        setBtnUp()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func setup() {
        view.addSubview(userImage)
        view.addSubview(nameLB)
        view.addSubview(userTF)
        view.addSubview(backBtn)
        view.addSubview(comfirmBtn)
        view.addSubview(addPicBtn)
        
        userImage.centerX(inView: view)
        userImage.anchor(top: view.topAnchor, paddingTop: 200, width: 250, height: 250)
        userImage.image = UIImage(named: "About us")
        userImage.contentMode = .scaleAspectFill
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = 30
        
        nameLB.anchor(top: userImage.bottomAnchor, paddingTop: 16)
        nameLB.centerX(inView: view)
        nameLB.textColor = .black
        nameLB.text = " Your Name "
        
        userTF.anchor(top: nameLB.bottomAnchor, paddingTop: 16, width: 200)
        userTF.centerX(inView: view)
        userTF.backgroundColor = .white
        userTF.textColor = .black
        userTF.placeholder = "Name"
        userTF.borderStyle = .roundedRect
        userTF.layer.borderWidth = 0.5
        
        backBtn.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 48, paddingRight: 24)
        backBtn.backgroundColor = .black
        
        comfirmBtn.anchor(bottom: view.bottomAnchor, paddingBottom: 24)
        comfirmBtn.centerX(inView: view)
        comfirmBtn.setTitle("Comfirm", for: .normal)
        comfirmBtn.backgroundColor = .dPeach
        
        addPicBtn.anchor(bottom: userImage.bottomAnchor, right: userImage.rightAnchor, paddingBottom: 8, paddingRight: 8)
        addPicBtn.setImage(addPic, for: .normal)
        addPicBtn.tintColor = .black
        
    }
    
    func setBtnUp() {
        
        backBtn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        addPicBtn.addTarget(self, action: #selector(uploadFrom), for: .touchUpInside)
        comfirmBtn.addTarget(self, action: #selector(tapToUpdate), for: .touchUpInside)
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
                            UserManager.shared.updateUserInfo(uid: userUid, image: "\(url)", name: userTF.text ?? "empty name") { result in
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
